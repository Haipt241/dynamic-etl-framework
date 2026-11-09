"""
PowerBI Integration Module

This module provides PowerBI integration capabilities for dynamic integrations.
Handles PowerBI template upload, dataset refresh, and workspace management.
"""

from .powerbi_manager import PowerBIManager
from .integration_powerbi import (
    PowerBIIntegration,
    upload_powerbi_template,
    refresh_powerbi_dataset,
    validate_powerbi_config,
    UploadPBITemplate,  # Backward compatibility
    RefreshPBIDataset   # Backward compatibility
)

__all__ = [
    'PowerBIManager',
    'PowerBIIntegration',
    'upload_powerbi_template',
    'refresh_powerbi_dataset', 
    'validate_powerbi_config',
    'UploadPBITemplate',
    'RefreshPBIDataset'
]