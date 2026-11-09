"""
Singleton Manager for Dynamic Integrations

Provides a centralized singleton pattern implementation to optimize resource
initialization and prevent redundant object creation during script execution.
"""

import threading
from typing import Type, Dict, Any, Optional


class SingletonMeta(type):
    """
    Thread-safe singleton metaclass implementation.
    
    This metaclass ensures that only one instance of each class exists
    and provides thread-safe initialization for concurrent environments.
    """
    _instances: Dict[Type, Any] = {}
    _lock: threading.Lock = threading.Lock()

    def __call__(cls, *args, **kwargs):
        """
        Thread-safe singleton instance creation.
        
        Returns existing instance if available, otherwise creates new one.
        """
        if cls not in cls._instances:
            with cls._lock:
                # Double-checked locking pattern
                if cls not in cls._instances:
                    instance = super().__call__(*args, **kwargs)
                    cls._instances[cls] = instance
        return cls._instances[cls]


class SingletonManager:
    """
    Centralized manager for singleton instances in dynamic integrations.
    
    Provides utilities for managing, clearing, and inspecting singleton instances
    across the entire dynamic integrations package.
    """
    
    @staticmethod
    def get_instance_count() -> int:
        """Get the total number of singleton instances currently cached."""
        return len(SingletonMeta._instances)
    
    @staticmethod
    def get_instance_types() -> list:
        """Get list of all singleton class types currently cached."""
        return list(SingletonMeta._instances.keys())
    
    @staticmethod
    def clear_instance(cls: Type) -> bool:
        """
        Clear a specific singleton instance.
        
        Args:
            cls: The class type to clear
            
        Returns:
            True if instance was cleared, False if not found
        """
        with SingletonMeta._lock:
            if cls in SingletonMeta._instances:
                del SingletonMeta._instances[cls]
                return True
            return False
    
    @staticmethod
    def clear_all_instances() -> int:
        """
        Clear all singleton instances.
        
        Returns:
            Number of instances that were cleared
        """
        with SingletonMeta._lock:
            count = len(SingletonMeta._instances)
            SingletonMeta._instances.clear()
            return count
    
    @staticmethod
    def has_instance(cls: Type) -> bool:
        """Check if a singleton instance exists for the given class."""
        return cls in SingletonMeta._instances
    
    @staticmethod
    def get_instance_info() -> Dict[str, Any]:
        """
        Get detailed information about all singleton instances.
        
        Returns:
            Dictionary with instance information including class names,
            memory addresses, and creation status
        """
        with SingletonMeta._lock:
            info = {}
            for cls, instance in SingletonMeta._instances.items():
                info[cls.__name__] = {
                    'class': cls,
                    'instance_id': id(instance),
                    'module': cls.__module__,
                    'memory_address': hex(id(instance))
                }
            return info


class SingletonBase(metaclass=SingletonMeta):
    """
    Base class for singleton objects in dynamic integrations.
    
    Classes inheriting from this will automatically become singletons
    with thread-safe initialization.
    
    Usage:
        class MyExtractor(SingletonBase):
            def __init__(self, config=None):
                if hasattr(self, '_initialized'):
                    return
                self._initialized = True
                # Initialization code here
                self.config = config
    """
    
    def __init__(self, *args, **kwargs):
        """
        Base singleton initialization.
        
        Subclasses should check for _initialized attribute to prevent
        re-initialization when singleton instance is reused.
        """
        if hasattr(self, '_initialized'):
            return
        self._initialized = True