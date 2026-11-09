"""
Distributed Token Lock Manager with DynamoDB
Implemented from xero-aws-only branch logic

Features:
- DynamoDB-based distributed locking
- Lock timeout and auto-cleanup
- Retry logic with exponential backoff
- Support for concurrent containers
- Context manager interface
"""

import time
import threading
import logging
import boto3
from typing import Optional
from botocore.exceptions import ClientError

# Setup logging
logger = logging.getLogger(__name__)


class TokenLockManagerNew:
    """
    Distributed token lock manager using DynamoDB
    Prevents race conditions when multiple containers/processes refresh token simultaneously
    """

    def __init__(
        self,
        table_name: str = 'etani-token-locks',
        region_name: str = 'us-east-1',
        lock_timeout: int = 120  # 2 minutes timeout
    ):
        """
        Initialize distributed lock manager

        Args:
            table_name: DynamoDB table name for locks (default: etani-token-locks)
            region_name: AWS region (default: us-east-1)
            lock_timeout: Lock timeout in seconds (default: 120 = 2 minutes)
        """
        self.table_name = table_name
        self.region_name = region_name
        self.lock_timeout = lock_timeout

        # Initialize DynamoDB client
        try:
            self.dynamodb = boto3.resource('dynamodb', region_name=self.region_name)
            self.table = self.dynamodb.Table(self.table_name)

            # Verify table exists (create table if not exists)
            self._ensure_table_exists()

        except Exception as e:
            logger.error(f"Failed to initialize DynamoDB: {e}")
            raise Exception(f"Unable to initialize DynamoDB lock manager: {e}")

    def _ensure_table_exists(self):
        """Ensure DynamoDB table exists, create if not exists"""
        try:
            # Try to describe table (check existence)
            self.table.meta.client.describe_table(TableName=self.table_name)
            logger.info(f"DynamoDB table {self.table_name} already exists")

        except ClientError as e:
            if e.response['Error']['Code'] == 'ResourceNotFoundException':
                # Table does not exist, create new one
                logger.info(f"Creating DynamoDB table: {self.table_name}")
                self._create_table()
            else:
                raise

    def _create_table(self):
        """Create DynamoDB table for token locks"""
        try:
            table = self.dynamodb.create_table(
                TableName=self.table_name,
                KeySchema=[
                    {
                        'AttributeName': 'token_filename',
                        'KeyType': 'HASH'  # Partition key
                    }
                ],
                AttributeDefinitions=[
                    {
                        'AttributeName': 'token_filename',
                        'AttributeType': 'S'
                    }
                ],
                BillingMode='PAY_PER_REQUEST',  # On-demand billing
                SSESpecification={
                    'Enabled': True  # Enable encryption at rest
                },
                Tags=[
                    {
                        'Key': 'Purpose',
                        'Value': 'TokenLocking'
                    },
                    {
                        'Key': 'Application',
                        'Value': 'EtaniETL'
                    }
                ]
            )

            # Wait for table to be created
            print(f"🔄 Waiting for DynamoDB table creation...")
            table.meta.client.get_waiter('table_exists').wait(TableName=self.table_name)
            print(f"✅ DynamoDB table created: {self.table_name}")

        except Exception as e:
            logger.error(f"Failed to create DynamoDB table: {e}")
            raise Exception(f"Unable to create DynamoDB table: {e}")

    def lock(self, token_filename: str, wait: bool = True) -> 'DistributedLockNew':
        """
        Context manager to acquire distributed lock

        Args:
            token_filename: Token filename to lock (e.g., 'CLIENT123_456.txt')
            wait: True = wait if lock busy, False = fail immediately

        Returns:
            DistributedLockNew: Context manager instance

        Usage:
            with lock_manager.lock('CLIENT123_456.txt', wait=True):
                # Token refresh logic here
                pass
        """
        return DistributedLockNew(self, token_filename, wait)

    def acquire_lock(
        self,
        token_filename: str,
        max_attempts: int = 12,
        wait_between_attempts: int = 10
    ) -> bool:
        """
        Acquire lock for token filename

        Args:
            token_filename: Token filename
            max_attempts: Maximum number of attempts (default: 12 = 2 minutes max wait)
            wait_between_attempts: Seconds to wait between attempts (default: 10s)

        Returns:
            bool: True if acquire successful

        Raises:
            RuntimeError: If unable to acquire lock after all attempts
        """
        current_time = int(time.time())
        expires_at = current_time + self.lock_timeout

        # Get thread/process identifier
        thread_id = threading.current_thread().ident
        process_id = threading.get_ident()
        lock_identifier = f"{process_id}_{thread_id}_{current_time}"

        for attempt in range(1, max_attempts + 1):
            try:
                # Try to create lock entry with condition: not exists
                self.table.put_item(
                    Item={
                        'token_filename': token_filename,
                        'locked_at': current_time,
                        'expires_at': expires_at,
                        'lock_identifier': lock_identifier,
                        'hostname': threading.current_thread().name
                    },
                    ConditionExpression='attribute_not_exists(token_filename)'
                )

                logger.info(f"Lock acquired: {token_filename} (attempt {attempt})")
                return True

            except ClientError as e:
                if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
                    # Lock already exists, check timeout and cleanup expired locks
                    if self._check_and_cleanup_expired_lock(token_filename):
                        # Expired lock cleaned up, retry
                        logger.info(f"Cleaned up expired lock, retrying: {token_filename}")
                        continue

                    # Lock still valid, wait or fail
                    if attempt < max_attempts:
                        logger.info(f"Lock busy: {token_filename}, waiting {wait_between_attempts}s (attempt {attempt}/{max_attempts})")
                        time.sleep(wait_between_attempts)
                        continue
                    else:
                        raise RuntimeError(
                            f"Cannot acquire lock for {token_filename} after {max_attempts} attempts "
                            f"(total wait: {max_attempts * wait_between_attempts}s)"
                        )
                else:
                    # Other DynamoDB error
                    logger.error(f"DynamoDB error acquiring lock: {e}")
                    raise Exception(f"DynamoDB error: {e}")

        raise RuntimeError(f"Lock acquisition failed after {max_attempts} attempts")

    def release_lock(self, token_filename: str) -> bool:
        """
        Release lock for token filename

        Args:
            token_filename: Token filename

        Returns:
            bool: True if release successful
        """
        try:
            self.table.delete_item(
                Key={'token_filename': token_filename}
            )
            logger.info(f"Lock released: {token_filename}")
            return True

        except Exception as e:
            logger.error(f"Error releasing lock for {token_filename}: {e}")
            return False

    def _check_and_cleanup_expired_lock(self, token_filename: str) -> bool:
        """
        Check and cleanup expired locks

        Args:
            token_filename: Token filename

        Returns:
            bool: True if lock has expired and was cleaned up
        """
        try:
            # Get current lock info
            response = self.table.get_item(
                Key={'token_filename': token_filename}
            )

            if 'Item' not in response:
                # No lock exists
                return True

            item = response['Item']
            current_time = int(time.time())
            expires_at = item.get('expires_at', 0)

            if current_time > expires_at:
                # Lock has expired, cleanup
                logger.info(f"Cleaning up expired lock: {token_filename} (expired {current_time - expires_at}s ago)")

                self.table.delete_item(
                    Key={'token_filename': token_filename},
                    ConditionExpression='expires_at = :expires_at',
                    ExpressionAttributeValues={
                        ':expires_at': expires_at
                    }
                )
                return True
            else:
                # Lock still valid
                remaining = expires_at - current_time
                logger.info(f"Lock still valid: {token_filename} (expires in {remaining}s)")
                return False

        except ClientError as e:
            if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
                # Lock was already cleaned up by another process
                return True
            else:
                logger.error(f"Error checking expired lock: {e}")
                return False

        except Exception as e:
            logger.error(f"Error checking expired lock: {e}")
            return False

    def cleanup_all_expired_locks(self) -> int:
        """
        Cleanup all expired locks (maintenance function)

        Returns:
            int: Number of locks cleaned up
        """
        cleaned_count = 0
        current_time = int(time.time())

        try:
            # Scan all locks
            response = self.table.scan()
            items = response.get('Items', [])

            for item in items:
                token_filename = item['token_filename']
                expires_at = item.get('expires_at', 0)

                if current_time > expires_at:
                    # Expired lock, cleanup
                    try:
                        self.table.delete_item(
                            Key={'token_filename': token_filename},
                            ConditionExpression='expires_at = :expires_at',
                            ExpressionAttributeValues={
                                ':expires_at': expires_at
                            }
                        )
                        cleaned_count += 1
                        logger.info(f"Cleaned up expired lock: {token_filename}")

                    except ClientError as e:
                        if e.response['Error']['Code'] != 'ConditionalCheckFailedException':
                            logger.error(f"Error cleaning up {token_filename}: {e}")

            logger.info(f"Cleanup completed: {cleaned_count} expired locks removed")
            return cleaned_count

        except Exception as e:
            logger.error(f"Error during cleanup: {e}")
            return cleaned_count


class DistributedLockNew:
    """
    Context manager for distributed locking
    Use with 'with' statement to ensure proper cleanup
    """

    def __init__(self, manager: TokenLockManagerNew, token_filename: str, wait: bool = True):
        """
        Initialize context manager

        Args:
            manager: TokenLockManagerNew instance
            token_filename: Token filename to lock
            wait: True = wait if lock busy, False = fail immediately
        """
        self.manager = manager
        self.token_filename = token_filename
        self.wait = wait
        self.lock_acquired = False

    def __enter__(self):
        """Enter context - acquire lock"""
        try:
            if self.wait:
                # Wait for lock with retry
                max_attempts = 12  # 2 minutes max wait
                self.lock_acquired = self.manager.acquire_lock(
                    self.token_filename,
                    max_attempts=max_attempts,
                    wait_between_attempts=10
                )
            else:
                # Fail immediately if lock busy
                self.lock_acquired = self.manager.acquire_lock(
                    self.token_filename,
                    max_attempts=1,
                    wait_between_attempts=0
                )

            if not self.lock_acquired:
                raise RuntimeError(f"Failed to acquire lock for {self.token_filename}")

            return self

        except Exception as e:
            logger.error(f"Error acquiring lock in context manager: {e}")
            raise

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Exit context - release lock"""
        if self.lock_acquired:
            try:
                self.manager.release_lock(self.token_filename)
            except Exception as e:
                logger.error(f"Error releasing lock in context manager: {e}")

        # Don't suppress exceptions
        return False


# Utility functions for backward compatibility
def create_token_lock_manager() -> TokenLockManagerNew:
    """
    Factory function to create token lock manager

    Returns:
        TokenLockManagerNew: Configured lock manager instance
    """
    return TokenLockManagerNew()


# CLI tool for testing and maintenance
def main():
    """CLI tool for testing token lock manager"""
    import argparse

    parser = argparse.ArgumentParser(description='Token Lock Manager CLI')
    parser.add_argument('command', choices=['test', 'cleanup'], help='Command to run')
    parser.add_argument('--token', default='TEST_123.txt', help='Token filename for testing')
    parser.add_argument('--table', default='etani-token-locks', help='DynamoDB table name')

    args = parser.parse_args()

    try:
        manager = TokenLockManagerNew(table_name=args.table)

        if args.command == 'test':
            print(f"Testing lock acquisition for token: {args.token}")

            # Test lock acquisition
            with manager.lock(args.token, wait=True):
                print(f"✅ Lock acquired successfully!")
                print(f"   Sleeping 5 seconds...")
                time.sleep(5)
                print(f"   Lock will be released when exiting context")

            print(f"✅ Lock released successfully!")

        elif args.command == 'cleanup':
            print(f"Cleaning up expired locks...")
            cleaned_count = manager.cleanup_all_expired_locks()
            print(f"✅ Cleaned up {cleaned_count} expired locks")

    except Exception as e:
        print(f"❌ Error: {e}")
        return 1

    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())