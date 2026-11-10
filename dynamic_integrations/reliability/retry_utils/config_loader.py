"""
Retry configuration loader

Loads and manages retry configurations from various sources.
Supports JSON files, environment variables, and programmatic configuration.
"""

import json
import os
from pathlib import Path
from typing import Dict, Any, Optional, Union, List
from dynamic_integrations.reliability.core.strategies import RetryStrategy, RetryConfig, StrategyFactory


class RetryConfigLoader:
    """
    Configuration loader for retry system
    
    Loads retry configurations from various sources and provides
    a unified interface for accessing retry settings.
    """
    
    def __init__(self, config_dir: Optional[Union[str, Path]] = None):
        """
        Initialize config loader
        
        Args:
            config_dir: Directory containing configuration files
        """
        self.config_dir = Path(config_dir) if config_dir else Path("retry_config")
        self._config_cache: Dict[str, Dict[str, Any]] = {}
    
    def load_config(self, config_name: str = "default") -> Dict[str, Any]:
        """
        Load retry configuration
        
        Args:
            config_name: Name of configuration to load
            
        Returns:
            Configuration dictionary
        """
        # Check cache first
        if config_name in self._config_cache:
            return self._config_cache[config_name]
        
        config = {}
        
        # Try to load from JSON file
        json_config = self._load_from_json(config_name)
        if json_config:
            config.update(json_config)
        
        # Override with environment variables
        env_config = self._load_from_env(config_name)
        if env_config:
            config.update(env_config)
        
        # Apply defaults if no config found
        if not config:
            config = self._get_default_config()
        
        # Cache the config
        self._config_cache[config_name] = config
        
        return config
    
    def _load_from_json(self, config_name: str) -> Optional[Dict[str, Any]]:
        """Load configuration from JSON file"""
        config_file = self.config_dir / f"{config_name}_retry_config.json"
        
        if not config_file.exists():
            # Try default location
            config_file = self.config_dir / "retry_config.json"
            
        if config_file.exists():
            try:
                with open(config_file, 'r') as f:
                    return json.load(f)
            except (json.JSONDecodeError, IOError) as e:
                print(f"⚠️ Warning: Failed to load config from {config_file}: {e}")
        
        return None

    @staticmethod
    def _load_from_env(config_name: str) -> Dict[str, Any]:
        """Load configuration from environment variables"""
        config = {}
        
        # Environment variable prefix
        prefix = f"RETRY_{config_name.upper()}_" if config_name != "default" else "RETRY_"
        
        # Check for strategy configurations
        for strategy in RetryStrategy:
            strategy_prefix = f"{prefix}{strategy.value.upper()}_"
            strategy_config = {}
            
            # Load strategy-specific settings
            if env_val := os.getenv(f"{strategy_prefix}MAX_ATTEMPTS"):
                try:
                    strategy_config['max_attempts'] = int(env_val)
                except ValueError:
                    pass
            
            if env_val := os.getenv(f"{strategy_prefix}BASE_DELAY"):
                try:
                    strategy_config['base_delay'] = float(env_val)
                except ValueError:
                    pass
            
            if env_val := os.getenv(f"{strategy_prefix}MAX_DELAY"):
                try:
                    strategy_config['max_delay'] = float(env_val)
                except ValueError:
                    pass
            
            if env_val := os.getenv(f"{strategy_prefix}MULTIPLIER"):
                try:
                    strategy_config['multiplier'] = float(env_val)
                except ValueError:
                    pass
            
            if env_val := os.getenv(f"{strategy_prefix}JITTER"):
                strategy_config['jitter'] = env_val.lower() in ('true', '1', 'yes')
            
            if strategy_config:
                if strategy.value not in config:
                    config[strategy.value] = {}
                config[strategy.value].update(strategy_config)
        
        # Global settings
        if env_val := os.getenv(f"{prefix}ENABLE_LOGGING"):
            config['enable_logging'] = env_val.lower() in ('true', '1', 'yes')
        
        if env_val := os.getenv(f"{prefix}INTEGRATION_NAME"):
            config['default_integration_name'] = env_val
        
        return config

    @staticmethod
    def _get_default_config() -> Dict[str, Any]:
        """Get default configuration"""
        return {
            'enable_logging': True,
            'default_integration_name': 'DYNAMIC_INTEGRATION',
            'database': {
                'max_attempts': 3,
                'base_delay': 2.0,
                'max_delay': 300.0,
                'multiplier': 2.0,
                'jitter': True
            },
            'api_calls': {
                'max_attempts': 5,
                'base_delay': 1.0,
                'max_delay': 60.0,
                'multiplier': 2.0,
                'jitter': True
            },
            'gateway_calls': {
                'max_attempts': 3,
                'base_delay': 5.0,
                'max_delay': 60.0,
                'multiplier': 2.0,
                'jitter': True
            },
            'generation': {
                'max_attempts': 2,
                'base_delay': 1.0,
                'max_delay': 10.0,
                'multiplier': 2.0,
                'jitter': False
            },
            'chunk_based': {
                'max_attempts': 2,
                'base_delay': 0.5,
                'max_delay': 5.0,
                'multiplier': 2.0,
                'jitter': False
            }
        }
    
    def create_retry_config(self, strategy: RetryStrategy, 
                          config_name: str = "default",
                          **overrides) -> RetryConfig:
        """
        Create RetryConfig instance from loaded configuration
        
        Args:
            strategy: Retry strategy to create config for
            config_name: Name of configuration to use
            **overrides: Configuration overrides
            
        Returns:
            RetryConfig instance
        """
        config = self.load_config(config_name)
        
        # Get strategy-specific config
        strategy_config = config.get(strategy.value, {})
        
        # Apply global defaults
        if 'enable_logging' in config:
            overrides.setdefault('enable_logging', config['enable_logging'])
        
        if 'default_integration_name' in config:
            overrides.setdefault('integration_name', config['default_integration_name'])
        
        # Merge strategy config with overrides
        final_config = strategy_config.copy()
        final_config.update(overrides)
        
        # Create using factory
        return StrategyFactory.create_config(strategy, **final_config)
    
    def save_config(self, config: Dict[str, Any], config_name: str = "default") -> Path:
        """
        Save configuration to JSON file
        
        Args:
            config: Configuration dictionary to save
            config_name: Name of configuration
            
        Returns:
            Path to saved configuration file
        """
        self.config_dir.mkdir(parents=True, exist_ok=True)
        
        config_file = self.config_dir / f"{config_name}_retry_config.json"
        
        with open(config_file, 'w') as f:
            json.dump(config, f, indent=2)
        
        # Update cache
        self._config_cache[config_name] = config
        
        return config_file
    
    def create_sample_config(self) -> Path:
        """
        Create a sample configuration file
        
        Returns:
            Path to created sample configuration file
        """
        sample_config = {
            "_comment": "Sample retry configuration - customize as needed",
            "enable_logging": True,
            "default_integration_name": "DYNAMIC_INTEGRATION", 
            
            "database": {
                "_comment": "Configuration for database operations",
                "max_attempts": 3,
                "base_delay": 2.0,
                "max_delay": 300.0,
                "multiplier": 2.0,
                "jitter": True,
                "exceptions": [
                    "SQLAlchemyError",
                    "OperationalError", 
                    "ProgrammingError"
                ]
            },
            
            "api_calls": {
                "_comment": "Configuration for general API calls",
                "max_attempts": 5,
                "base_delay": 1.0,
                "max_delay": 60.0,
                "multiplier": 2.0,
                "jitter": True,
                "exceptions": [
                    "RequestException",
                    "HTTPError",
                    "ConnectionError",
                    "Timeout"
                ]
            },
            
            "gateway_calls": {
                "_comment": "Configuration for gateway API calls (502, 503, 504)",
                "max_attempts": 3,
                "base_delay": 5.0,
                "max_delay": 60.0, 
                "multiplier": 2.0,
                "jitter": True,
                "exceptions": [
                    "HTTPError",
                    "ConnectionError"
                ]
            },
            
            "generation": {
                "_comment": "Configuration for LLM/AI generation operations",
                "max_attempts": 2,
                "base_delay": 1.0,
                "max_delay": 10.0,
                "multiplier": 2.0,
                "jitter": False,
                "exceptions": [
                    "GenerationError",
                    "ParsingError",
                    "TimeoutError"
                ]
            },
            
            "chunk_based": {
                "_comment": "Configuration for chunk processing operations",
                "max_attempts": 2,
                "base_delay": 0.5,
                "max_delay": 5.0,
                "multiplier": 2.0,
                "jitter": False,
                "exceptions": [
                    "ChunkProcessingError",
                    "ValidationError"
                ]
            }
        }
        
        return self.save_config(sample_config, "sample")
    
    def list_configs(self) -> List[str]:
        """
        List available configuration files
        
        Returns:
            List of configuration names
        """
        if not self.config_dir.exists():
            return []
        
        configs = []
        for config_file in self.config_dir.glob("*_retry_config.json"):
            config_name = config_file.stem.replace("_retry_config", "")
            configs.append(config_name)
        
        # Also check for default config file
        if (self.config_dir / "retry_config.json").exists():
            configs.append("default")
        
        return sorted(configs)

    @staticmethod
    def validate_config(config: Dict[str, Any]) -> List[str]:
        """
        Validate configuration
        
        Args:
            config: Configuration to validate
            
        Returns:
            List of validation errors (empty if valid)
        """
        errors = []
        
        # Check strategy configurations
        for strategy in RetryStrategy:
            if strategy.value in config:
                strategy_config = config[strategy.value]
                
                # Validate numeric values
                for key, expected_type in [
                    ('max_attempts', int),
                    ('base_delay', (int, float)),
                    ('max_delay', (int, float)),
                    ('multiplier', (int, float))
                ]:
                    if key in strategy_config:
                        value = strategy_config[key]
                        if not isinstance(value, expected_type):
                            errors.append(f"{strategy.value}.{key} must be {expected_type.__name__}")
                        elif key == 'max_attempts' and value <= 0:
                            errors.append(f"{strategy.value}.max_attempts must be positive")
                        elif key in ['base_delay', 'max_delay'] and value < 0:
                            errors.append(f"{strategy.value}.{key} must be non-negative")
                        elif key == 'multiplier' and value <= 0:
                            errors.append(f"{strategy.value}.multiplier must be positive")
                
                # Validate boolean values
                if 'jitter' in strategy_config and not isinstance(strategy_config['jitter'], bool):
                    errors.append(f"{strategy.value}.jitter must be boolean")
                
                # Validate max_delay >= base_delay
                if 'base_delay' in strategy_config and 'max_delay' in strategy_config:
                    if strategy_config['max_delay'] < strategy_config['base_delay']:
                        errors.append(f"{strategy.value}.max_delay must be >= base_delay")
        
        return errors