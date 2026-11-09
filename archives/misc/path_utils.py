"""
Path utilities for dynamic path resolution in the ETL project.
This module provides functions to resolve project paths dynamically,
making the project portable across different environments.
"""

import os
import sys
from pathlib import Path


def get_project_root() -> Path:
    """
    Get the project root directory (the parent of etl_packages).
    
    Returns:
        Path: The project root directory
    """
    # Start from the current file's location
    current_file = Path(__file__)
    
    # Navigate to etl_packages directory
    etl_packages_dir = current_file.parent
    
    # Navigate to project root (parent of etl_packages)
    project_root = etl_packages_dir.parent
    
    return project_root


def get_etl_packages_path() -> Path:
    """
    Get the etl_packages directory path.
    
    Returns:
        Path: The etl_packages directory path
    """
    return get_project_root() / "etl_packages"


def setup_project_paths():
    """
    Set up the Python path to include the necessary project directories.
    This function should be called at the beginning of scripts that need
    to import from the project modules.
    """
    project_root = get_project_root()
    etl_packages_path = get_etl_packages_path()
    
    # Add project root to Python path
    if str(project_root) not in sys.path:
        sys.path.insert(0, str(project_root))
    
    # Add etl_packages to Python path
    if str(etl_packages_path) not in sys.path:
        sys.path.insert(0, str(etl_packages_path))
    
    # Add dynamic_integrations subdirectory if it exists
    dynamic_integrations_path = etl_packages_path / "dynamic_integrations"
    if dynamic_integrations_path.exists() and str(dynamic_integrations_path) not in sys.path:
        sys.path.insert(0, str(dynamic_integrations_path))
    
    # Add integrations subdirectory if it exists
    integrations_path = etl_packages_path / "integrations"
    if integrations_path.exists() and str(integrations_path) not in sys.path:
        sys.path.insert(0, str(integrations_path))


def get_relative_path(relative_path: str) -> Path:
    """
    Get an absolute path relative to the project root.
    
    Args:
        relative_path: Path relative to project root
        
    Returns:
        Path: Absolute path
    """
    return get_project_root() / relative_path


def get_etl_packages_relative_path(relative_path: str) -> Path:
    """
    Get an absolute path relative to the etl_packages directory.
    
    Args:
        relative_path: Path relative to etl_packages directory
        
    Returns:
        Path: Absolute path
    """
    return get_etl_packages_path() / relative_path


# Convenience function to get common paths
def get_json_dir() -> Path:
    """Get the json directory path."""
    return get_etl_packages_relative_path("json")


def get_logs_dir() -> Path:
    """Get the logs directory path."""
    return get_etl_packages_relative_path("logs")


def get_tests_dir() -> Path:
    """Get the tests directory path."""
    return get_etl_packages_relative_path("tests")


def get_demo_dir() -> Path:
    """Get the demo directory path."""
    return get_etl_packages_relative_path("demo") 