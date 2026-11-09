"""
Interfaces package for the ETL Integration System
Contains abstract base classes and interfaces for plug-and-play integrations.
"""

from .IIntegrationAPI import IIntegrationAPI
from .IPackageRequestManager import IPackageRequestManager
from .ITokenManager import ITokenManager

__all__ = [
    'IIntegrationAPI',
    'IPackageRequestManager', 
    'ITokenManager'
]