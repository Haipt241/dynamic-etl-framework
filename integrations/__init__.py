"""
Integrations package for the ETL Integration System
Contains concrete implementations for different accounting systems and integrations.
"""

from .xeroblue_integration import XeroBlueIntegration

__all__ = [
    'XeroBlueIntegration'
]

# Integration registry for dynamic loading
AVAILABLE_INTEGRATIONS = {
    'XEROBLUE': XeroBlueIntegration,
    'xeroblue': XeroBlueIntegration,
    'xero': XeroBlueIntegration,
    'XeroBlue': XeroBlueIntegration
}