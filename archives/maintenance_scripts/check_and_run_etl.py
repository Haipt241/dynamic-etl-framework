#!/usr/bin/env python3
"""
ETL Script Selector
Determines whether to run INSERT.py or UPSERT.py based on table existence

Usage:
    python check_and_run_etl.py

Environment Variables Required:
    - EtaniClientID: Client ID (e.g., 'SWAU_CLIENT1913')
    - EtaniOrganisationID: Organisation ID
    - XeroTenantID: Xero Tenant ID
    - DB_Destination: Database destination
    - JOB_ID: Job ID
    - JOB_RUN_ID: Job Run ID
    - TRIGGER_TYPE: Trigger type
"""

import os
import sys
import subprocess
import logging

# Container monitoring (optional - won't crash if not available)
try:
    from container_monitoring_client import ContainerMonitoringClient
    MONITORING_ENABLED = True
except ImportError:
    MONITORING_ENABLED = False
    logging.warning("Container monitoring client not available")

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    stream=sys.stdout
)
logger = logging.getLogger(__name__)

def extract_client_id_number(etani_client_id):
    """
    Extract numeric client ID from EtaniClientID.
    Example: 'SWAU_CLIENT1913' → '1913'
    """
    if not etani_client_id:
        return None

    if 'CLIENT' in etani_client_id:
        parts = etani_client_id.split('CLIENT')
        if len(parts) > 1:
            return parts[1].strip('_')

    return None


def main():
    """Main entry point"""

    # Get environment variables
    etani_client_id = os.getenv('EtaniClientID')
    etani_org_id = os.getenv('EtaniOrganisationID')
    xero_tenant_id = os.getenv('XeroTenantID')
    job_id = os.getenv('JOB_ID')
    job_run_id = os.getenv('JOB_RUN_ID')
    trigger_type = os.getenv('TRIGGER_TYPE')

    if not etani_client_id or not etani_org_id:
        logger.error("❌ Missing required environment variables: EtaniClientID and EtaniOrganisationID")
        sys.exit(1)

    logger.info("="*60)
    logger.info("ETL Script Selector")
    logger.info("="*60)
    logger.info(f"Client ID: {etani_client_id}")
    logger.info(f"Organisation ID: {etani_org_id}")
    logger.info(f"Tenant ID: {xero_tenant_id}")
    logger.info("")

    # Initialize container monitoring
    container_log_id = None
    container_client = None

    if MONITORING_ENABLED:
        etl_api_url = os.getenv('ETL_API_URL')
        etl_api_key = os.getenv('ETL_API_KEY')

        if etl_api_url and etl_api_key:
            try:
                logger.info("📊 Initializing container monitoring...")
                container_client = ContainerMonitoringClient(etl_api_url, etl_api_key)

                # Extract numeric IDs
                client_id_num = extract_client_id_number(etani_client_id)
                org_id_num = int(etani_org_id) if etani_org_id else None

                container_log_id = container_client.start_container(
                    integration='xero_sync',
                    organisation_id=org_id_num,
                    client_id=int(client_id_num) if client_id_num else None,
                    job_id=int(job_id) if job_id else None,
                    job_run_id=int(job_run_id) if job_run_id else None,
                    trigger_type=trigger_type
                )

                if container_log_id:
                    logger.info(f"✓ Container monitoring started: {container_log_id}")
                else:
                    logger.warning("⚠️  Container monitoring failed to start")

            except Exception as e:
                logger.warning(f"⚠️  Container monitoring unavailable: {e}")
        else:
            logger.info("ℹ️  Container monitoring disabled (missing API credentials)")

    logger.info("")

    # Extract numeric client ID
    client_id_number = extract_client_id_number(etani_client_id)

    if not client_id_number:
        logger.error(f"❌ Could not extract numeric client ID from: {etani_client_id}")
        logger.info("📝 Running INSERT.py (safe default for new clients)")
        script_to_run = "XEROBLUE - INSERT.py"
    else:
        logger.info(f"✓ Extracted client ID number: {client_id_number}")

        # Check TRIGGER_TYPE first - FORCE mode always drops and recreates
        if trigger_type == 'FORCE':
            logger.info("🔥 FORCE MODE DETECTED")
            logger.info("   → Will DROP all production tables and recreate with new schema")
            logger.info("   → This includes adding PRIMARY KEY constraints")
            logger.info("   → Running INSERT.py for full table reload")
            script_to_run = "XEROBLUE - INSERT.py"
        else:
            # Normal/Scheduled mode: check if tables exist
            try:
                from sql_helper import check_required_tables_exist

                logger.info("🔍 Checking if required tables exist...")
                # Pass org_id to check for org-specific stage tables
                result = check_required_tables_exist(client_id_number, org_id=etani_org_id)

                if result['all_exist']:
                    logger.info("✅ All required tables exist")
                    logger.info(f"   Checked: {', '.join(result['checked_tables'])}")
                    logger.info("📝 Running UPSERT.py (update existing data)")
                    script_to_run = "XEROBLUE - UPSERT.py"
                else:
                    logger.warning("⚠️  Some required tables are missing:")
                    for table in result['missing_tables']:
                        logger.warning(f"   - {table}")
                    logger.info("📝 Running INSERT.py (create tables and initial data)")
                    script_to_run = "XEROBLUE - INSERT.py"

            except Exception as e:
                logger.error(f"❌ Error checking tables: {e}")
                logger.info("📝 Running INSERT.py (safe default on error)")
                script_to_run = "XEROBLUE - INSERT.py"

    logger.info("")
    logger.info("="*60)
    logger.info(f"🚀 Executing: {script_to_run}")
    logger.info("="*60)
    logger.info("")

    # Execute the selected script
    try:
        # Run the script using python3 with unbuffered output
        result = subprocess.run(
            ["python3", "-u", script_to_run],
            cwd=os.path.dirname(os.path.abspath(__file__)),
            check=True
        )

        logger.info("")
        logger.info("="*60)
        logger.info(f"✅ {script_to_run} completed successfully")
        logger.info("="*60)

        # Mark container as successful
        if container_client and container_log_id:
            try:
                container_client.complete_container(
                    container_log_id=container_log_id,
                    status="success"
                )
                logger.info("✓ Container monitoring completed")
            except Exception as e:
                logger.warning(f"⚠️  Failed to complete container monitoring: {e}")

        sys.exit(result.returncode)

    except subprocess.CalledProcessError as e:
        logger.error("")
        logger.error("="*60)
        logger.error(f"❌ {script_to_run} failed with exit code: {e.returncode}")
        logger.error("="*60)

        # Mark container as failed
        if container_client and container_log_id:
            try:
                container_client.complete_container(
                    container_log_id=container_log_id,
                    status="failed",
                    error_details=f"{script_to_run} failed with exit code {e.returncode}"
                )
                logger.info("✓ Container monitoring completed (failed status)")
            except Exception as e2:
                logger.warning(f"⚠️  Failed to complete container monitoring: {e2}")

        sys.exit(e.returncode)

    except Exception as e:
        logger.error("")
        logger.error("="*60)
        logger.error(f"❌ Unexpected error: {e}")
        logger.error("="*60)

        # Mark container as failed
        if container_client and container_log_id:
            try:
                container_client.complete_container(
                    container_log_id=container_log_id,
                    status="failed",
                    error_details=f"Unexpected error: {str(e)}"
                )
                logger.info("✓ Container monitoring completed (failed status)")
            except Exception as e2:
                logger.warning(f"⚠️  Failed to complete container monitoring: {e2}")

        sys.exit(1)


if __name__ == "__main__":
    main()
