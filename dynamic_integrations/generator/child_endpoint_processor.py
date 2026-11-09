"""
Universal Child Endpoint Processor
Handles parent-child relationships between endpoints where child endpoints require parent IDs
"""

import re
import logging
from typing import Dict, List, Tuple, Optional, Any
from dataclasses import dataclass


@dataclass
class ParentDependency:
    """Represents parent dependency information"""
    parent_table: str
    parent_id_field: str
    placeholder: str
    level: int = 1  # Dependency level (1 = direct parent, 2 = grandparent, etc.)
    depends_on: Optional['ParentDependency'] = None  # For nested dependencies


class ChildEndpointProcessor:
    """Universal processor for child endpoints across all integrations"""
    
    def __init__(self, integration_name: str, client_id: str = None):
        self.integration_name = integration_name.lower()
        self.client_id = client_id
        self.logger = logging.getLogger(f"ChildEndpointProcessor.{integration_name.upper()}")
        
    
    def is_child_endpoint(self, url: str) -> bool:
        """
        Detect if endpoint URL contains parent dependency placeholders
        
        Args:
            url: API endpoint URL
            
        Returns:
            bool: True if endpoint requires parent ID
        """
        # Look for patterns like {parent_id}, {employee_id}, etc.
        placeholder_pattern = r'\{[^}]*_?id\}'
        return bool(re.search(placeholder_pattern, url, re.IGNORECASE))
    
    def get_parent_dependency(self, url: str) -> Optional[ParentDependency]:
        """
        Extract parent dependency information from URL using generic pattern matching
        
        Args:
            url: API endpoint URL with placeholders
            
        Returns:
            ParentDependency object or None if no dependency found
        """
        # Check for multi-level dependencies first
        multi_level_deps = self.get_multi_level_dependencies(url)
        if multi_level_deps:
            return multi_level_deps[-1]  # Return the deepest dependency (which links to parent)
        
        # Fallback to single-level dependency detection
        return self._get_single_level_dependency(url)
    
    def get_multi_level_dependencies(self, url: str) -> List[ParentDependency]:
        """
        Extract multiple levels of parent dependencies from URL
        
        Args:
            url: API endpoint URL with placeholders
            
        Returns:
            List of ParentDependency objects ordered from root to deepest
        """
        # Find all {*_id} patterns in the URL
        id_patterns = re.findall(r'/([^/]+)/\{([^}]*[_]?[iI]d)\}', url, re.IGNORECASE)
        
        if len(id_patterns) <= 1:
            return []  # Single or no dependency, handle in single-level method
        
        dependencies = []
        
        for i, (parent_path_segment, placeholder_name) in enumerate(id_patterns):
            parent_entity = parent_path_segment.lower()
            placeholder = f"{{{placeholder_name}}}"
            parent_table = f"c{{{self.client_id or 'clientID'}}}_{self.integration_name}_{parent_entity}"
            
            # Create dependency with level and parent reference
            depends_on = dependencies[-1] if dependencies else None
            
            dependency = ParentDependency(
                parent_table=parent_table,
                parent_id_field='ID',
                placeholder=placeholder,
                level=i + 1,
                depends_on=depends_on
            )
            
            dependencies.append(dependency)
        
        if dependencies:
            self.logger.debug(f"Detected multi-level dependencies in {url}: {[dep.placeholder for dep in dependencies]}")
        
        return dependencies
    
    def _get_single_level_dependency(self, url: str) -> Optional[ParentDependency]:
        """
        Extract single-level parent dependency from URL
        
        Args:
            url: API endpoint URL with placeholders
            
        Returns:
            ParentDependency object or None if no dependency found
        """
        # Generic pattern to match any {*_id} or {*Id} placeholder
        # Examples: {employee_id}, {job_id}, {quote_id}, {device_id}, etc.
        generic_pattern = r'/([^/]+)/\{([^}]*[_]?[iI]d)\}/'
        
        match = re.search(generic_pattern, url, re.IGNORECASE)
        if match:
            parent_path_segment = match.group(1)  # e.g., "employees", "jobs", "quotes", "storageDevices"
            placeholder_name = match.group(2)     # e.g., "employee_id", "job_id", "quote_id"
            
            # Extract parent entity name from path segment
            # Keep the entity name as-is (with plural form if that's how it appears in the URL)
            parent_entity = parent_path_segment.lower()
            
            # Build the actual placeholder with curly braces
            placeholder = f"{{{placeholder_name}}}"
            
            # Build parent table name
            parent_table = f"c{{{self.client_id or 'clientID'}}}_{self.integration_name}_{parent_entity}"
            
            self.logger.debug(f"Detected single-level dependency: {url} -> {parent_entity} via {placeholder}")
            
            return ParentDependency(
                parent_table=parent_table,
                parent_id_field='ID',
                placeholder=placeholder
            )
        
        self.logger.debug(f"No parent dependency pattern found in URL: {url}")
        return None
    
    def get_parent_ids_from_db(self, parent_table: str, parent_id_field: str, 
                              batch_size: int = 100, offset: int = 0) -> List[str]:
        """
        Query parent IDs from database in batches
        
        Args:
            parent_table: Name of parent table
            parent_id_field: Name of ID field
            batch_size: Number of IDs to fetch per batch
            offset: Offset for pagination
            
        Returns:
            List of parent IDs
        """
        # This would be implemented by the specific integration class
        # that has database access
        raise NotImplementedError("Database access must be implemented by integration class")
    
    def substitute_placeholder(self, url_template: str, parent_id: str, 
                              placeholder: str) -> str:
        """
        Replace placeholder in URL with actual parent ID
        
        Args:
            url_template: URL with placeholder
            parent_id: Actual parent ID to substitute
            placeholder: Placeholder pattern to replace
            
        Returns:
            URL with placeholder replaced
        """
        # Handle both {employee_id} and %7Bemployee_id%7D (URL encoded)
        encoded_placeholder = placeholder.replace('{', '%7B').replace('}', '%7D')
        
        # Replace both encoded and non-encoded versions
        url = url_template.replace(placeholder, str(parent_id))
        url = url.replace(encoded_placeholder, str(parent_id))
        
        return url
    
    def generate_child_urls(self, url_template: str, parent_ids: List[str]) -> List[str]:
        """
        Generate list of child URLs using parent IDs
        
        Args:
            url_template: URL template with placeholders
            parent_ids: List of parent IDs
            
        Returns:
            List of URLs with IDs substituted
        """
        dependency = self.get_parent_dependency(url_template)
        if not dependency:
            return []
        
        urls = []
        for parent_id in parent_ids:
            child_url = self.substitute_placeholder(
                url_template, parent_id, dependency.placeholder
            )
            urls.append(child_url)
        
        return urls
    
    def generate_multi_level_urls(self, url_template: str, dependencies: List[ParentDependency]) -> List[str]:
        """
        Generate URLs for multi-level dependencies recursively
        
        Args:
            url_template: URL template with multiple placeholders
            dependencies: List of dependencies from root to deepest
            
        Returns:
            List of fully resolved URLs
        """
        if not dependencies:
            return [url_template]
        
        # Start with root dependency (first level)
        root_dependency = dependencies[0]
        
        # This method would need to be implemented by the integration class
        # as it requires database access to get parent IDs
        raise NotImplementedError("Multi-level URL generation requires database access - implement in integration class")
    
    def get_processing_info(self, url: str) -> Dict[str, Any]:
        """
        Get comprehensive processing information for an endpoint
        
        Args:
            url: Endpoint URL
            
        Returns:
            Dict with processing information
        """
        info = {
            'is_child': self.is_child_endpoint(url),
            'url': url,
            'requires_batch_processing': False,
            'parent_dependency': None
        }
        
        if info['is_child']:
            dependency = self.get_parent_dependency(url)
            info['parent_dependency'] = dependency
            info['requires_batch_processing'] = True
            
        return info
    
    def log_endpoint_analysis(self, endpoints: List[str]) -> None:
        """
        Log analysis of all endpoints for debugging
        
        Args:
            endpoints: List of endpoint URLs to analyze
        """
        self.logger.info(f"🔍 Analyzing {len(endpoints)} endpoints for {self.integration_name.upper()}")
        
        child_count = 0
        parent_count = 0
        
        for url in endpoints:
            info = self.get_processing_info(url)
            if info['is_child']:
                child_count += 1
                dep = info['parent_dependency']
                if dep:
                    self.logger.info(f"🔗 Child endpoint: {url}")
                    self.logger.info(f"   → Depends on: {dep.parent_table}.{dep.parent_id_field}")
                else:
                    self.logger.warning(f"⚠️ Child endpoint with unknown dependency: {url}")
            else:
                parent_count += 1
                self.logger.debug(f"🌳 Parent endpoint: {url}")
        
        self.logger.info(f"📊 Analysis complete: {parent_count} parent, {child_count} child endpoints")


# Integration helper methods for database access
class ChildEndpointMixin:
    """
    Mixin class to add child endpoint processing capabilities to integration classes
    """
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.child_processor = ChildEndpointProcessor(
            integration_name=getattr(self, 'integration_name', 'unknown'),
            client_id=getattr(self, 'client_id', None)
        )
    
    def process_endpoint_with_dependencies(self, endpoint_name: str, url: str, 
                                         batch_size: int = 100) -> bool:
        """
        Process endpoint handling parent-child dependencies
        
        Args:
            endpoint_name: Name of the endpoint
            url: Endpoint URL (may contain placeholders)
            batch_size: Batch size for processing parent IDs
            
        Returns:
            bool: True if processing was successful
        """
        info = self.child_processor.get_processing_info(url)
        
        if not info['is_child']:
            # Regular endpoint processing
            return self.sync_endpoint_data(endpoint_name, url)
        
        # Child endpoint processing
        dependency = info['parent_dependency']
        if not dependency:
            self.logger.error(f"❌ Cannot process child endpoint {endpoint_name}: No dependency info")
            return False
        
        self.logger.info(f"🔄 Processing child endpoint {endpoint_name} with parent dependency")
        
        # Process in batches
        offset = 0
        total_processed = 0
        
        while True:
            try:
                # Get batch of parent IDs from database
                parent_ids = self.get_parent_ids_batch(
                    dependency.parent_table, 
                    dependency.parent_id_field,
                    batch_size, 
                    offset
                )
                
                if not parent_ids:
                    break
                
                # Generate child URLs for this batch
                child_urls = self.child_processor.generate_child_urls(url, parent_ids)
                
                # Process each child URL
                for child_url in child_urls:
                    success = self.sync_endpoint_data(endpoint_name, child_url)
                    if success:
                        total_processed += 1
                
                self.logger.info(f"✅ Processed batch {offset//batch_size + 1}: {len(parent_ids)} parent IDs")
                offset += batch_size
                
            except Exception as e:
                self.logger.error(f"❌ Error processing batch at offset {offset}: {e}")
                break
        
        self.logger.info(f"🎯 Child endpoint {endpoint_name} complete: {total_processed} records processed")
        return total_processed > 0
    
    def get_parent_ids_batch(self, parent_table: str, parent_id_field: str,
                           batch_size: int, offset: int) -> List[str]:
        """
        Get batch of parent IDs from database - to be implemented by subclass
        
        Args:
            parent_table: Parent table name
            parent_id_field: Parent ID field name
            batch_size: Number of IDs to fetch
            offset: Offset for pagination
            
        Returns:
            List of parent IDs
        """
        raise NotImplementedError("Subclass must implement get_parent_ids_batch method")


