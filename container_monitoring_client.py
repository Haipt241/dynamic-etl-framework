"""
Container Monitoring Client for ETL Containers
Manages container lifecycle logging
"""
import logging

logger = logging.getLogger(__name__)


class ContainerMonitoringClient:
    """Client for tracking container execution lifecycle"""

    def __init__(self, api_url: str, api_key: str):
        """
        Initialize client

        Args:
            api_url: API base URL (e.g., REDACTED)
            api_key: ETL API write key
        """
        self.api_url = api_url.rstrip('/')
        self.api_key = api_key

    def start_container(self, integration: str, organisation_id: int,
                       client_id: int = None, firm_id: int = None,
                       job_id: int = None, job_run_id: int = None,
                       trigger_type: str = None):
        """
        Start a container and get container_log_id

        Args:
            integration: Integration name (e.g., 'xero_sync', 'myob_sync')
            organisation_id: Organisation ID
            client_id: Optional client ID
            firm_id: Optional firm ID
            job_id: Optional job ID
            job_run_id: Optional job run ID
            trigger_type: Optional trigger type (e.g., 'MANUAL', 'SCHEDULED')

        Returns:
            str: container_log_id to use for query logging
        """
        import requests

        endpoint_url = f"{self.api_url}/container-logs"

        payload = {
            'integration': integration,
            'status': 'running'
        }

        # Add optional fields
        if organisation_id is not None:
            payload['organisation_id'] = organisation_id
        if client_id is not None:
            payload['client_id'] = client_id
        if firm_id is not None:
            payload['firm_id'] = firm_id
        if job_id is not None:
            payload['job_id'] = job_id
        if job_run_id is not None:
            payload['job_run_id'] = job_run_id
        if trigger_type:
            payload['trigger_type'] = trigger_type

        try:
            logger.info(f"[Container Monitoring] Starting container for {integration}")
            response = requests.post(
                endpoint_url,
                headers={
                    'X-API-Key': self.api_key,
                    'Content-Type': 'application/json'
                },
                json=payload,
                timeout=30
            )
            response.raise_for_status()
            result = response.json()

            # API returns log_id
            container_log_id = result.get('log_id')
            logger.info(f"[Container Monitoring] Container started: {container_log_id}")

            return container_log_id

        except Exception as e:
            logger.error(f"[Container Monitoring] Failed to start container: {e}")
            # Return None - monitoring failures shouldn't crash ETL
            return None

    def complete_container(self, container_log_id: str, status: str = "success",
                          error_details: str = None):
        """
        Mark container as complete

        Args:
            container_log_id: Container log ID from start_container()
            status: Status ('success', 'failed', 'completed_with_errors', etc.)
            error_details: Optional error details if failed

        Returns:
            API response dict
        """
        import requests

        if not container_log_id:
            logger.warning("[Container Monitoring] No container_log_id to complete")
            return {'success': False, 'error': 'No container_log_id provided'}

        endpoint_url = f"{self.api_url}/container-logs/{container_log_id}"

        payload = {
            'status': status
        }

        if error_details:
            payload['error_details'] = error_details

        try:
            logger.info(f"[Container Monitoring] Completing container: {container_log_id} ({status})")
            response = requests.patch(
                endpoint_url,
                headers={
                    'X-API-Key': self.api_key,
                    'Content-Type': 'application/json'
                },
                json=payload,
                timeout=30
            )
            response.raise_for_status()
            result = response.json()

            logger.info(f"[Container Monitoring] Container completed successfully")
            return result

        except Exception as e:
            logger.error(f"[Container Monitoring] Failed to complete container: {e}")
            # Don't raise - monitoring failures shouldn't crash ETL
            return {'success': False, 'error': str(e)}
