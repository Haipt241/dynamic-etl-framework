"""
Integrations package for the ETL Integration System
Contains concrete implementations for different accounting systems and integrations.
"""

from .xeroblue_integration import XeroblueIntegration

__all__ = [
    'XeroblueIntegration'
]

# Integration registry for dynamic loading
AVAILABLE_INTEGRATIONS = {
    'XEROBLUE': XeroblueIntegration,
    'xeroblue': XeroblueIntegration,
    'xero': XeroblueIntegration,
    'XeroBlue': XeroblueIntegration
}