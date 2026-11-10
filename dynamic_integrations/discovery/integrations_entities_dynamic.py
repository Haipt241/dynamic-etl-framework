import requests
import re
import json
from typing import Dict, List, Optional, Tuple, Any, Union
from dataclasses import dataclass, field
from urllib.parse import urlparse, urljoin, parse_qs
from bs4 import BeautifulSoup
import logging
from sqlalchemy import Column, Integer, String, Text, DateTime, Boolean, Float, JSON
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import time
import hashlib
from abc import ABC, abstractmethod

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

Base = declarative_base()

@dataclass
class FieldSchema:
    """Represents a field in an entity schema"""
    name: str
    field_type: str
    required: bool = False
    description: str = ""
    max_length: Optional[int] = None
    is_array: bool = False
    nested_fields: List['FieldSchema'] = field(default_factory=list)
    enum_values: List[str] = field(default_factory=list)

@dataclass
class EntityInfo:
    """Represents basic entity information"""
    name: str
    url: str
    description: str = ""
    category: str = ""
    methods: List[str] = field(default_factory=list)
    endpoint: str = ""

@dataclass
class EntitySchema:
    """Represents an entity schema from API documentation"""
    name: str
    fields: List[FieldSchema] = field(default_factory=list)
    description: str = ""
    table_name: str = ""
    endpoint: str = ""
    methods: List[str] = field(default_factory=list)
    
    def __post_init__(self):
        if not self.table_name:
            self.table_name = self.name.lower()

@dataclass
class APIDiscoveryResult:
    """Result of API discovery process"""
    api_name: str
    base_url: str
    version: str
    entities: List[EntityInfo] = field(default_factory=list)
    categories: List[str] = field(default_factory=list)
    authentication_type: str = ""
    rate_limits: Dict[str, Any] = field(default_factory=dict)

class APIDocumentationParser(ABC):
    """Abstract base class for parsing API documentation"""
    
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        })
        self.cache = {}
        self.rate_limit_delay = 1.0  # seconds between requests
    
    def fetch_page(self, url: str) -> str:
        """Fetch a web page and return its content with caching"""
        cache_key = hashlib.md5(url.encode()).hexdigest()
        
        if cache_key in self.cache:
            return self.cache[cache_key]
        
        try:
            time.sleep(self.rate_limit_delay)  # Rate limiting
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            content = response.text
            self.cache[cache_key] = content
            return content
        except requests.RequestException as e:
            logger.error(f"Error fetching {url}: {e}")
            raise
    
    @abstractmethod
    def parse_entity_schema(self, url: str) -> EntitySchema:
        """Parse entity schema from API documentation URL"""
        pass
    
    @abstractmethod
    def discover_entities(self, base_url: str) -> APIDiscoveryResult:
        """Discover all entities from API documentation"""
        pass

class DynamicAPIParser(APIDocumentationParser):
    """Dynamic parser that can handle various API documentation formats"""
    
    def __init__(self):
        super().__init__()
        self.api_patterns = {
            'rest': [
                r'(/api/v?\d+/\w+)',
                r'(/v\d+/\w+)',
                r'(/\w+/api/\w+)',
                r'(/docs/api/\w+)',
                r'(/documentation/api/\w+)',
            ],
            'endpoint_indicators': [
                'endpoint', 'api', 'resource', 'entity', 'object', 'model'
            ],
            'field_indicators': [
                'field', 'property', 'attribute', 'parameter', 'column'
            ],
            'type_indicators': [
                'type', 'format', 'data type', 'field type'
            ]
        }
    
    def discover_entities(self, base_url: str) -> APIDiscoveryResult:
        """Discover all entities from API documentation"""
        logger.info(f"Starting API discovery for: {base_url}")
        
        parsed_url = urlparse(base_url)
        domain = parsed_url.netloc
        
        # Initialize result
        result = APIDiscoveryResult(
            api_name=self._extract_api_name(domain),
            base_url=base_url,
            version=self._extract_version(base_url)
        )
        
        # Fetch main page
        try:
            main_content = self.fetch_page(base_url)
            soup = BeautifulSoup(main_content, 'html.parser')
            
            # Try different discovery strategies
            entities = []
            
            # Strategy 1: Look for navigation links
            entities.extend(self._discover_from_navigation(soup, base_url))
            
            # Strategy 2: Look for API reference sections
            entities.extend(self._discover_from_api_reference(soup, base_url))
            
            # Strategy 3: Look for OpenAPI/Swagger documentation
            entities.extend(self._discover_from_openapi(soup, base_url))
            
            # Strategy 4: Look for endpoint lists
            entities.extend(self._discover_from_endpoint_lists(soup, base_url))
            
            # Strategy 5: Sitemap discovery
            entities.extend(self._discover_from_sitemap(base_url))
            
            # Remove duplicates
            seen = set()
            unique_entities = []
            for entity in entities:
                key = (entity.name, entity.url)
                if key not in seen:
                    seen.add(key)
                    unique_entities.append(entity)
            
            result.entities = unique_entities
            result.categories = list(set(entity.category for entity in unique_entities if entity.category))
            
            logger.info(f"Discovered {len(unique_entities)} entities across {len(result.categories)} categories")
            
        except Exception as e:
            logger.error(f"Error during API discovery: {e}")
            raise
        
        return result
    
    def _extract_api_name(self, domain: str) -> str:
        """Extract API name from domain"""
        # Remove common prefixes/suffixes
        name = domain.replace('api.', '').replace('developer.', '').replace('docs.', '')
        name = name.split('.')[0]
        return name.title()
    
    def _extract_version(self, url: str) -> str:
        """Extract API version from URL"""
        version_patterns = [
            r'/v(\d+(?:\.\d+)*)',
            r'/api/v(\d+(?:\.\d+)*)',
            r'version[=:](\d+(?:\.\d+)*)',
        ]
        
        for pattern in version_patterns:
            match = re.search(pattern, url, re.IGNORECASE)
            if match:
                return match.group(1)
        
        return "1.0"
    
    def _discover_from_navigation(self, soup: BeautifulSoup, base_url: str) -> List[EntityInfo]:
        """Discover entities from navigation menus"""
        entities = []
        
        # Look for navigation elements
        nav_selectors = [
            'nav ul li a',
            '.nav-menu a',
            '.sidebar a',
            '.navigation a',
            '.menu a',
            '.api-nav a',
            '.docs-nav a'
        ]
        
        for selector in nav_selectors:
            links = soup.select(selector)
            for link in links:
                href = link.get('href')
                text = link.get_text(strip=True)
                
                if href and text and self._is_entity_link(href, text):
                    entity = self._create_entity_from_link(href, text, base_url)
                    if entity:
                        entities.append(entity)
        
        return entities
    
    def _discover_from_api_reference(self, soup: BeautifulSoup, base_url: str) -> List[EntityInfo]:
        """Discover entities from API reference sections"""
        entities = []
        
        # Look for API reference sections
        ref_selectors = [
            '.api-reference a',
            '.reference a',
            '.endpoints a',
            '.resources a',
            '.api-docs a',
            'section[id*="api"] a',
            'div[class*="api"] a'
        ]
        
        for selector in ref_selectors:
            links = soup.select(selector)
            for link in links:
                href = link.get('href')
                text = link.get_text(strip=True)
                
                if href and text and self._is_entity_link(href, text):
                    entity = self._create_entity_from_link(href, text, base_url)
                    if entity:
                        entities.append(entity)
        
        return entities
    
    def _discover_from_openapi(self, soup: BeautifulSoup, base_url: str) -> List[EntityInfo]:
        """Discover entities from OpenAPI/Swagger documentation"""
        entities = []
        
        # Look for OpenAPI/Swagger links
        openapi_patterns = [
            'openapi.json',
            'swagger.json',
            'swagger.yaml',
            'openapi.yaml',
            'api-docs'
        ]
        
        links = soup.find_all('a', href=True)
        for link in links:
            href = link.get('href')
            for pattern in openapi_patterns:
                if pattern in href.lower():
                    try:
                        openapi_url = urljoin(base_url, href)
                        openapi_entities = self._parse_openapi_spec(openapi_url)
                        entities.extend(openapi_entities)
                    except Exception as e:
                        logger.warning(f"Failed to parse OpenAPI spec {href}: {e}")
        
        return entities
    
    def _discover_from_endpoint_lists(self, soup: BeautifulSoup, base_url: str) -> List[EntityInfo]:
        """Discover entities from endpoint lists"""
        entities = []
        
        # Look for tables or lists that might contain endpoints
        table_selectors = [
            'table',
            '.endpoint-table',
            '.api-table',
            '.reference-table'
        ]
        
        for selector in table_selectors:
            tables = soup.select(selector)
            for table in tables:
                entities.extend(self._parse_endpoint_table(table, base_url))
        
        return entities
    
    def _discover_from_sitemap(self, base_url: str) -> List[EntityInfo]:
        """Discover entities from sitemap"""
        entities = []
        
        sitemap_urls = [
            urljoin(base_url, '/sitemap.xml'),
            urljoin(base_url, '/sitemap_index.xml'),
            urljoin(base_url, '/robots.txt')
        ]
        
        for sitemap_url in sitemap_urls:
            try:
                content = self.fetch_page(sitemap_url)
                if sitemap_url.endswith('.xml'):
                    entities.extend(self._parse_sitemap_xml(content, base_url))
                else:
                    entities.extend(self._parse_robots_txt(content, base_url))
            except Exception as e:
                logger.debug(f"Could not fetch sitemap {sitemap_url}: {e}")
        
        return entities
    
    def _is_entity_link(self, href: str, text: str) -> bool:
        """Check if a link likely points to an entity documentation"""
        # Skip non-relevant links
        skip_patterns = [
            'javascript:', 'mailto:', 'tel:', '#',
            'github.com', 'twitter.com', 'facebook.com',
            'linkedin.com', 'youtube.com', 'instagram.com',
            '.pdf', '.zip', '.tar', '.gz'
        ]
        
        for pattern in skip_patterns:
            if pattern in href.lower():
                return False
        
        # Check for entity indicators in URL or text
        entity_indicators = [
            'account', 'user', 'customer', 'client', 'contact',
            'invoice', 'bill', 'payment', 'transaction', 'order',
            'product', 'item', 'service', 'inventory',
            'report', 'dashboard', 'analytics',
            'organization', 'company', 'tenant',
            'employee', 'payroll', 'time', 'expense',
            'project', 'task', 'time', 'budget',
            'tax', 'rate', 'category', 'class',
            'asset', 'liability', 'equity',
            'journal', 'ledger', 'balance'
        ]
        
        href_lower = href.lower()
        text_lower = text.lower()
        
        for indicator in entity_indicators:
            if indicator in href_lower or indicator in text_lower:
                return True
        
        # Check for API path patterns
        api_patterns = [
            r'/api/.*?/\w+',
            r'/v\d+/\w+',
            r'/docs/.*?/\w+',
            r'/documentation/.*?/\w+'
        ]
        
        for pattern in api_patterns:
            if re.search(pattern, href_lower):
                return True
        
        return False
    
    def _create_entity_from_link(self, href: str, text: str, base_url: str) -> Optional[EntityInfo]:
        """Create an EntityInfo object from a link"""
        try:
            full_url = urljoin(base_url, href)
            
            # Extract entity name from URL or text
            entity_name = self._extract_entity_name_from_url(href) or self._clean_entity_name(text)
            
            if not entity_name:
                return None
            
            # Determine category
            category = self._determine_category(entity_name, href, text)
            
            # Extract description
            description = self._clean_description(text)
            
            return EntityInfo(
                name=entity_name,
                url=full_url,
                description=description,
                category=category,
                endpoint=self._extract_endpoint(href)
            )
        except Exception as e:
            logger.debug(f"Failed to create entity from link {href}: {e}")
            return None
    
    def _extract_entity_name_from_url(self, url: str) -> Optional[str]:
        """Extract entity name from URL"""
        # Remove query parameters
        url = url.split('?')[0]
        
        # Split by / and get meaningful parts
        parts = [p for p in url.split('/') if p and p not in ['api', 'v1', 'v2', 'v3', 'docs', 'documentation']]
        
        if parts:
            # Get the last meaningful part
            name = parts[-1]
            # Convert to title case
            name = name.replace('-', ' ').replace('_', ' ')
            return ''.join(word.capitalize() for word in name.split())
        
        return None
    
    def _clean_entity_name(self, text: str) -> str:
        """Clean and normalize entity name"""
        # Remove common prefixes/suffixes
        text = re.sub(r'^(API|REST|HTTP|GET|POST|PUT|DELETE|PATCH)\s+', '', text, flags=re.IGNORECASE)
        text = re.sub(r'\s+(API|REST|HTTP|Endpoint|Resource)$', '', text, flags=re.IGNORECASE)
        
        # Convert to title case
        text = text.strip().title()
        
        # Remove special characters
        text = re.sub(r'[^\w\s]', '', text)
        
        return text
    
    def _clean_description(self, text: str) -> str:
        """Clean and normalize description"""
        # Remove excessive whitespace
        text = re.sub(r'\s+', ' ', text).strip()
        
        # Limit length
        if len(text) > 200:
            text = text[:200] + '...'
        
        return text
    
    def _determine_category(self, entity_name: str, href: str, text: str) -> str:
        """Determine entity category based on name and context"""
        name_lower = entity_name.lower()
        href_lower = href.lower()
        text_lower = text.lower()
        
        category_mapping = {
            'Core': ['account', 'user', 'customer', 'client', 'contact', 'organization', 'company', 'tenant'],
            'Transaction': ['invoice', 'bill', 'payment', 'order', 'purchase', 'sale', 'receipt', 'credit', 'debit'],
            'Reference': ['tax', 'rate', 'category', 'class', 'type', 'code', 'setting', 'preference'],
            'Report': ['report', 'dashboard', 'analytics', 'summary', 'statement', 'balance'],
            'Payroll': ['employee', 'payroll', 'salary', 'wage', 'timesheet', 'leave', 'benefit'],
            'Asset': ['asset', 'inventory', 'item', 'product', 'service', 'equipment'],
            'Project': ['project', 'task', 'time', 'budget', 'milestone', 'resource'],
            'File': ['file', 'document', 'attachment', 'upload', 'download', 'media']
        }
        
        content = f"{name_lower} {href_lower} {text_lower}"
        
        for category, keywords in category_mapping.items():
            if any(keyword in content for keyword in keywords):
                return category
        
        return 'Other'
    
    def _extract_endpoint(self, href: str) -> str:
        """Extract API endpoint from URL"""
        # Look for API patterns in URL
        api_patterns = [
            r'(/api/v?\d*/[^/]+)',
            r'(/v\d+/[^/]+)',
            r'(/[^/]+/api/[^/]+)'
        ]
        
        for pattern in api_patterns:
            match = re.search(pattern, href)
            if match:
                return match.group(1)
        
        return href
    
    def _parse_openapi_spec(self, openapi_url: str) -> List[EntityInfo]:
        """Parse OpenAPI/Swagger specification"""
        entities = []
        
        try:
            content = self.fetch_page(openapi_url)
            
            # Try to parse as JSON first
            try:
                spec = json.loads(content)
            except json.JSONDecodeError:
                # Try YAML if JSON fails
                try:
                    import yaml
                    spec = yaml.safe_load(content)
                except ImportError:
                    logger.warning("PyYAML not installed, cannot parse YAML OpenAPI specs")
                    return entities
                except:
                    logger.warning("Failed to parse OpenAPI spec as JSON or YAML")
                    return entities
            
            # Extract entities from paths
            if 'paths' in spec:
                for path, methods in spec['paths'].items():
                    entity_name = self._extract_entity_name_from_path(path)
                    if entity_name:
                        description = ""
                        available_methods = []
                        
                        # Get description from any method
                        for method, method_spec in methods.items():
                            if isinstance(method_spec, dict):
                                available_methods.append(method.upper())
                                if 'description' in method_spec and not description:
                                    description = method_spec['description']
                                elif 'summary' in method_spec and not description:
                                    description = method_spec['summary']
                        
                        base_url = openapi_url.replace('/openapi.json', '').replace('/swagger.json', '')
                        entity_url = urljoin(base_url, f'/docs/api/{entity_name.lower()}')
                        
                        entities.append(EntityInfo(
                            name=entity_name,
                            url=entity_url,
                            description=description,
                            category=self._determine_category(entity_name, path, description),
                            methods=available_methods,
                            endpoint=path
                        ))
        
        except Exception as e:
            logger.warning(f"Failed to parse OpenAPI spec: {e}")
        
        return entities
    
    def _extract_entity_name_from_path(self, path: str) -> Optional[str]:
        """Extract entity name from API path"""
        # Remove path parameters
        path = re.sub(r'\{[^}]+\}', '', path)
        
        # Split path and get meaningful parts
        parts = [p for p in path.split('/') if p and p not in ['api', 'v1', 'v2', 'v3', 'rest']]
        
        if parts:
            # Get the first meaningful part (usually the resource name)
            name = parts[0]
            # Convert to singular if it's plural
            if name.endswith('s') and len(name) > 1:
                name = name[:-1]
            return name.title()
        
        return None
    
    def _parse_endpoint_table(self, table, base_url: str) -> List[EntityInfo]:
        """Parse endpoint information from HTML table"""
        entities = []
        
        rows = table.find_all('tr')
        if not rows:
            return entities
        
        # Try to identify relevant columns
        header_row = rows[0]
        headers = [th.get_text(strip=True).lower() for th in header_row.find_all(['th', 'td'])]
        
        # Find relevant column indices
        endpoint_col = None
        method_col = None
        description_col = None
        
        for i, header in enumerate(headers):
            if any(indicator in header for indicator in ['endpoint', 'url', 'path', 'resource']):
                endpoint_col = i
            elif any(indicator in header for indicator in ['method', 'verb', 'http']):
                method_col = i
            elif any(indicator in header for indicator in ['description', 'summary', 'purpose']):
                description_col = i
        
        # Parse data rows
        for row in rows[1:]:
            cells = row.find_all(['td', 'th'])
            if len(cells) > max(endpoint_col or 0, method_col or 0, description_col or 0):
                try:
                    endpoint = cells[endpoint_col].get_text(strip=True) if endpoint_col is not None else ""
                    method = cells[method_col].get_text(strip=True) if method_col is not None else ""
                    description = cells[description_col].get_text(strip=True) if description_col is not None else ""
                    
                    if endpoint:
                        entity_name = self._extract_entity_name_from_path(endpoint)
                        if entity_name:
                            entity_url = urljoin(base_url, f'/docs/api/{entity_name.lower()}')
                            entities.append(EntityInfo(
                                name=entity_name,
                                url=entity_url,
                                description=description,
                                category=self._determine_category(entity_name, endpoint, description),
                                methods=[method.upper()] if method else [],
                                endpoint=endpoint
                            ))
                except Exception as e:
                    logger.debug(f"Failed to parse table row: {e}")
        
        return entities
    
    def _parse_sitemap_xml(self, content: str, base_url: str) -> List[EntityInfo]:
        """Parse sitemap XML for API documentation URLs"""
        entities = []
        
        try:
            soup = BeautifulSoup(content, 'xml')
            urls = soup.find_all('url')
            
            for url in urls:
                loc = url.find('loc')
                if loc:
                    url_text = loc.get_text()
                    if self._is_api_doc_url(url_text):
                        entity_name = self._extract_entity_name_from_url(url_text)
                        if entity_name:
                            entities.append(EntityInfo(
                                name=entity_name,
                                url=url_text,
                                description=f"API documentation for {entity_name}",
                                category="Core"
                            ))
        except Exception as e:
            logger.debug(f"Failed to parse sitemap XML: {e}")
        
        return entities
    
    def _parse_robots_txt(self, content: str, base_url: str) -> List[EntityInfo]:
        """Parse robots.txt for sitemap references"""
        entities = []
        
        lines = content.split('\n')
        for line in lines:
            if line.strip().lower().startswith('sitemap:'):
                sitemap_url = line.split(':', 1)[1].strip()
                try:
                    entities.extend(self._discover_from_sitemap(sitemap_url))
                except Exception as e:
                    logger.debug(f"Failed to parse sitemap from robots.txt: {e}")
        
        return entities
    
    def _is_api_doc_url(self, url: str) -> bool:
        """Check if URL is likely API documentation"""
        api_indicators = [
            '/api/', '/docs/', '/documentation/', '/reference/',
            '/v1/', '/v2/', '/v3/', '/rest/', '/graphql/'
        ]
        
        return any(indicator in url.lower() for indicator in api_indicators)
    
    def parse_entity_schema(self, url: str) -> EntitySchema:
        """Parse entity schema from API documentation URL"""
        try:
            content = self.fetch_page(url)
            soup = BeautifulSoup(content, 'html.parser')
            
            # Extract entity name from URL
            entity_name = self._extract_entity_name_from_url(url) or "Unknown"
            
            # Parse fields from the documentation
            fields = self._parse_fields_from_content(soup)
            
            # Get entity description
            description = self._extract_description(soup)
            
            # Extract endpoint information
            endpoint = self._extract_endpoint_from_content(soup)
            
            # Extract supported methods
            methods = self._extract_methods_from_content(soup)
            
            return EntitySchema(
                name=entity_name,
                fields=fields,
                description=description,
                endpoint=endpoint,
                methods=methods
            )
        except Exception as e:
            logger.error(f"Failed to parse entity schema from {url}: {e}")
            raise
    
    def _parse_fields_from_content(self, soup: BeautifulSoup) -> List[FieldSchema]:
        """Parse fields from BeautifulSoup content"""
        fields = []
        
        # Strategy 1: Look for tables with field definitions
        tables = soup.find_all('table')
        for table in tables:
            table_fields = self._parse_table_fields(table)
            fields.extend(table_fields)
        
        # Strategy 2: Look for JSON schema examples
        code_blocks = soup.find_all(['code', 'pre'])
        for code in code_blocks:
            try:
                code_text = code.get_text()
                if '{' in code_text or '[' in code_text:
                    json_fields = self._parse_json_schema(code_text)
                    fields.extend(json_fields)
            except:
                continue
        
        # Strategy 3: Look for parameter lists
        param_lists = soup.find_all(['dl', 'ul', 'ol'])
        for param_list in param_lists:
            if self._looks_like_parameter_list(param_list):
                param_fields = self._parse_parameter_list(param_list)
                fields.extend(param_fields)
        
        # Remove duplicates
        seen = set()
        unique_fields = []
        for field in fields:
            key = (field.name, field.field_type)
            if key not in seen:
                seen.add(key)
                unique_fields.append(field)
        
        return unique_fields
    
    def _parse_table_fields(self, table) -> List[FieldSchema]:
        """Parse fields from HTML table"""
        fields = []
        rows = table.find_all('tr')
        
        if not rows:
            return fields
        
        # Try to identify relevant columns
        header_row = rows[0]
        headers = [th.get_text(strip=True).lower() for th in header_row.find_all(['th', 'td'])]
        
        # Find relevant column indices
        name_col = None
        type_col = None
        desc_col = None
        required_col = None
        
        for i, header in enumerate(headers):
            if any(indicator in header for indicator in ['name', 'field', 'property', 'parameter']):
                name_col = i
            elif any(indicator in header for indicator in ['type', 'format', 'data type']):
                type_col = i
            elif any(indicator in header for indicator in ['description', 'summary', 'purpose']):
                desc_col = i
            elif any(indicator in header for indicator in ['required', 'mandatory', 'optional']):
                required_col = i
        
        # Parse data rows
        for row in rows[1:]:
            cells = row.find_all(['td', 'th'])
            if len(cells) > max(name_col or 0, type_col or 0, desc_col or 0, required_col or 0):
                try:
                    name = cells[name_col].get_text(strip=True) if name_col is not None else ""
                    field_type = cells[type_col].get_text(strip=True) if type_col is not None else "string"
                    description = cells[desc_col].get_text(strip=True) if desc_col is not None else ""
                    required_text = cells[required_col].get_text(strip=True).lower() if required_col is not None else ""
                    
                    if name and name.lower() not in ['name', 'field', 'property', 'parameter']:
                        required = 'required' in required_text or 'mandatory' in required_text
                        
                        fields.append(FieldSchema(
                            name=name,
                            field_type=self._normalize_type(field_type),
                            description=description,
                            required=required
                        ))
                except Exception as e:
                    logger.debug(f"Failed to parse table row: {e}")
        
        return fields
    
    def _parse_json_schema(self, json_text: str) -> List[FieldSchema]:
        """Parse fields from JSON schema example"""
        fields = []
        
        try:
            # Clean the JSON text
            json_text = json_text.strip()
            
            # Try to extract JSON from code blocks
            if not json_text.startswith('{') and not json_text.startswith('['):
                start = json_text.find('{')
                end = json_text.rfind('}') + 1
                if start != -1 and end > start:
                    json_text = json_text[start:end]
            
            # Parse JSON
            data = json.loads(json_text)
            
            if isinstance(data, dict):
                fields = self._extract_fields_from_json(data)
            elif isinstance(data, list) and data and isinstance(data[0], dict):
                fields = self._extract_fields_from_json(data[0])
        
        except json.JSONDecodeError:
            # If JSON parsing fails, try to extract field names from text
            lines = json_text.split('\n')
            for line in lines:
                if ':' in line and not line.strip().startswith('//'):
                    try:
                        field_name = line.split(':')[0].strip().strip('"\'')
                        if field_name and field_name.isidentifier():
                            fields.append(FieldSchema(
                                name=field_name,
                                field_type="string"
                            ))
                    except:
                        continue
        
        return fields
    
    def _extract_fields_from_json(self, data: Dict[str, Any], prefix: str = "") -> List[FieldSchema]:
        """Recursively extract fields from JSON data"""
        fields = []
        
        for key, value in data.items():
            field_name = f"{prefix}.{key}" if prefix else key
            
            if isinstance(value, dict):
                # Nested object
                fields.append(FieldSchema(
                    name=field_name,
                    field_type="object",
                    nested_fields=self._extract_fields_from_json(value, field_name)
                ))
            elif isinstance(value, list):
                # Array field
                if value and isinstance(value[0], dict):
                    fields.append(FieldSchema(
                        name=field_name,
                        field_type="array",
                        is_array=True,
                        nested_fields=self._extract_fields_from_json(value[0], field_name)
                    ))
                else:
                    fields.append(FieldSchema(
                        name=field_name,
                        field_type="array",
                        is_array=True
                    ))
            else:
                # Simple field
                fields.append(FieldSchema(
                    name=field_name,
                    field_type=self._infer_type_from_value(value)
                ))
        
        return fields
    
    def _looks_like_parameter_list(self, element) -> bool:
        """Check if element looks like a parameter list"""
        text = element.get_text().lower()
        indicators = ['parameter', 'field', 'property', 'attribute', 'query', 'header', 'body']
        return any(indicator in text for indicator in indicators)
    
    def _parse_parameter_list(self, param_list) -> List[FieldSchema]:
        """Parse fields from parameter list"""
        fields = []
        
        # Handle definition lists (dl)
        if param_list.name == 'dl':
            terms = param_list.find_all('dt')
            descriptions = param_list.find_all('dd')
            
            for term, desc in zip(terms, descriptions):
                name = term.get_text(strip=True)
                description = desc.get_text(strip=True)
                
                # Try to extract type from description
                field_type = self._extract_type_from_description(description)
                
                fields.append(FieldSchema(
                    name=name,
                    field_type=field_type,
                    description=description
                ))
        
        # Handle unordered/ordered lists (ul/ol)
        else:
            items = param_list.find_all('li')
            for item in items:
                text = item.get_text(strip=True)
                
                # Try to parse "name - description" or "name: description" format
                if ' - ' in text:
                    parts = text.split(' - ', 1)
                    name = parts[0].strip()
                    description = parts[1].strip()
                elif ': ' in text:
                    parts = text.split(': ', 1)
                    name = parts[0].strip()
                    description = parts[1].strip()
                else:
                    name = text
                    description = ""
                
                field_type = self._extract_type_from_description(description)
                
                fields.append(FieldSchema(
                    name=name,
                    field_type=field_type,
                    description=description
                ))
        
        return fields
    
    def _extract_type_from_description(self, description: str) -> str:
        """Extract field type from description text"""
        desc_lower = description.lower()
        
        # Look for explicit type mentions
        type_patterns = [
            (r'\bstring\b', 'string'),
            (r'\binteger\b', 'integer'),
            (r'\bint\b', 'integer'),
            (r'\bnumber\b', 'decimal'),
            (r'\bfloat\b', 'decimal'),
            (r'\bdouble\b', 'decimal'),
            (r'\bdecimal\b', 'decimal'),
            (r'\bboolean\b', 'boolean'),
            (r'\bbool\b', 'boolean'),
            (r'\bdate\b', 'datetime'),
            (r'\bdatetime\b', 'datetime'),
            (r'\btimestamp\b', 'datetime'),
            (r'\barray\b', 'array'),
            (r'\blist\b', 'array'),
            (r'\bobject\b', 'object'),
            (r'\bjson\b', 'object'),
            (r'\bguid\b', 'string'),
            (r'\buuid\b', 'string'),
        ]
        
        for pattern, field_type in type_patterns:
            if re.search(pattern, desc_lower):
                return field_type
        
        return 'string'
    
    def _normalize_type(self, type_str: str) -> str:
        """Normalize field type string"""
        type_str = type_str.lower().strip()
        
        type_mapping = {
            'string': 'string',
            'str': 'string',
            'text': 'string',
            'varchar': 'string',
            'char': 'string',
            'integer': 'integer',
            'int': 'integer',
            'number': 'decimal',
            'decimal': 'decimal',
            'float': 'decimal',
            'double': 'decimal',
            'numeric': 'decimal',
            'boolean': 'boolean',
            'bool': 'boolean',
            'bit': 'boolean',
            'date': 'datetime',
            'datetime': 'datetime',
            'timestamp': 'datetime',
            'time': 'datetime',
            'guid': 'string',
            'uuid': 'string',
            'enum': 'string',
            'array': 'array',
            'list': 'array',
            'object': 'object',
            'json': 'object',
            'dict': 'object',
        }
        
        return type_mapping.get(type_str, 'string')
    
    def _infer_type_from_value(self, value: Any) -> str:
        """Infer field type from value"""
        if isinstance(value, bool):
            return 'boolean'
        elif isinstance(value, int):
            return 'integer'
        elif isinstance(value, float):
            return 'decimal'
        elif isinstance(value, str):
            # Check if it looks like a GUID
            if len(value) == 36 and value.count('-') == 4:
                return 'string'
            # Check if it looks like a date
            if 'T' in value and ('Z' in value or '+' in value or '-' in value):
                return 'datetime'
            return 'string'
        elif isinstance(value, list):
            return 'array'
        elif isinstance(value, dict):
            return 'object'
        else:
            return 'string'
    
    def _extract_description(self, soup: BeautifulSoup) -> str:
        """Extract entity description from documentation"""
        # Look for description in various places
        desc_selectors = [
            'meta[name="description"]',
            'p.description',
            '.entity-description',
            'div.overview p',
            'h1 + p',
            '.lead',
            'article p:first-of-type',
            'main p:first-of-type',
            '.summary',
            '.intro p'
        ]
        
        for selector in desc_selectors:
            if selector.startswith('meta'):
                element = soup.select_one(selector)
                if element:
                    return element.get('content', '')
            else:
                element = soup.select_one(selector)
                if element:
                    desc = element.get_text(strip=True)
                    if len(desc) > 20:  # Skip very short descriptions
                        return desc
        
        return ""
    
    def _extract_endpoint_from_content(self, soup: BeautifulSoup) -> str:
        """Extract API endpoint from content"""
        # Look for code blocks or elements that might contain endpoints
        code_selectors = [
            'code',
            'pre',
            '.endpoint',
            '.api-endpoint',
            '.url',
            '.path'
        ]
        
        for selector in code_selectors:
            elements = soup.select(selector)
            for element in elements:
                text = element.get_text(strip=True)
                # Look for patterns that look like API endpoints
                if text.startswith('/') and any(part in text for part in ['api', 'v1', 'v2', 'v3']):
                    return text
        
        return ""
    
    def _extract_methods_from_content(self, soup: BeautifulSoup) -> List[str]:
        """Extract supported HTTP methods from content"""
        methods = []
        text = soup.get_text().upper()
        
        http_methods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'HEAD', 'OPTIONS']
        for method in http_methods:
            if method in text:
                methods.append(method)
        
        return methods

class MySQLTableGenerator:
    """Generate MySQL CREATE TABLE statements from entity schemas"""
    
    def __init__(self, table_prefix: str = ""):
        self.table_prefix = table_prefix
    
    def generate_create_table(self, schema: EntitySchema) -> str:
        """Generate MySQL CREATE TABLE statement"""
        table_name = f"{self.table_prefix}{schema.table_name}"
        
        columns = []
        columns.append("id INT AUTO_INCREMENT PRIMARY KEY")
        
        for field in schema.fields:
            columns.append(self._generate_column_definition(field))
        
        # Add standard audit columns
        columns.extend([
            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP",
            "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP",
            "organisation_id VARCHAR(50)",
            "tenant_id VARCHAR(50)",
            "etl_batch_id VARCHAR(100)",
            "api_endpoint VARCHAR(255)",
            "sync_status VARCHAR(50) DEFAULT 'pending'"
        ])
        
        create_statement = f"""
CREATE TABLE IF NOT EXISTS `{table_name}` (
    {','.join(columns)}
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
"""
        return create_statement.strip()
    
    def _generate_column_definition(self, field: FieldSchema) -> str:
        """Generate column definition for a field"""
        column_name = self._sanitize_column_name(field.name)
        column_type = self._get_mysql_type(field)
        
        definition = f"`{column_name}` {column_type}"
        
        if field.required:
            definition += " NOT NULL"
        else:
            definition += " NULL"
        
        if field.description:
            # Escape single quotes in description
            escaped_desc = field.description.replace("'", "''")
            definition += f" COMMENT '{escaped_desc}'"
        
        return definition
    
    def _sanitize_column_name(self, name: str) -> str:
        """Sanitize column name for MySQL"""
        # Replace dots with underscores for nested fields
        name = name.replace('.', '_')
        # Remove special characters
        name = re.sub(r'[^a-zA-Z0-9_]', '_', name)
        # Ensure it doesn't start with a number
        if name and name[0].isdigit():
            name = f"field_{name}"
        return name
    
    def _get_mysql_type(self, field: FieldSchema) -> str:
        """Get MySQL column type for field"""
        type_mapping = {
            'string': 'VARCHAR(255)',
            'integer': 'INT',
            'decimal': 'DECIMAL(19,4)',
            'boolean': 'BOOLEAN',
            'datetime': 'DATETIME',
            'object': 'JSON',
            'array': 'JSON'
        }
        
        base_type = type_mapping.get(field.field_type, 'VARCHAR(255)')
        
        # Handle text fields that might be longer
        if field.field_type == 'string' and field.max_length:
            if field.max_length > 255:
                return 'TEXT'
            else:
                return f'VARCHAR({field.max_length})'
        
        return base_type

class SQLAlchemyModelGenerator:
    """Generate SQLAlchemy ORM model classes from entity schemas"""
    
    def __init__(self, table_prefix: str = ""):
        self.table_prefix = table_prefix
    
    def generate_model_class(self, schema: EntitySchema) -> str:
        """Generate SQLAlchemy model class"""
        class_name = self._get_class_name(schema.name)
        table_name = f"{self.table_prefix}{schema.table_name}"
        
        columns = []
        columns.append("id = Column(Integer, primary_key=True, autoincrement=True)")
        
        for field in schema.fields:
            columns.append(self._generate_column_definition(field))
        
        # Add standard audit columns
        columns.extend([
            "created_at = Column(DateTime, default=datetime.utcnow)",
            "updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)",
            "organisation_id = Column(String(50))",
            "tenant_id = Column(String(50))",
            "etl_batch_id = Column(String(100))",
            "api_endpoint = Column(String(255))",
            "sync_status = Column(String(50), default='pending')"
        ])
        
        model_class = f'''
class {class_name}(Base):
    """
    {schema.description}
    API Endpoint: {schema.endpoint}
    Methods: {', '.join(schema.methods)}
    """
    __tablename__ = "{table_name}"
    
    {chr(10).join(f"    {col}" for col in columns)}
    
    def __repr__(self):
        return f"<{class_name}(id={{self.id}})>"
'''
        return model_class.strip()
    
    def _get_class_name(self, entity_name: str) -> str:
        """Generate class name from entity name"""
        # Convert to PascalCase
        name = ''.join(word.capitalize() for word in entity_name.split('_'))
        return name
    
    def _generate_column_definition(self, field: FieldSchema) -> str:
        """Generate SQLAlchemy column definition"""
        column_name = self._sanitize_column_name(field.name)
        column_type = self._get_sqlalchemy_type(field)
        
        definition = f"{column_name} = Column({column_type}"
        
        if not field.required:
            definition += ", nullable=True"
        
        definition += ")"
        
        return definition
    
    def _sanitize_column_name(self, name: str) -> str:
        """Sanitize column name for Python"""
        # Replace dots with underscores for nested fields
        name = name.replace('.', '_')
        # Remove special characters
        name = re.sub(r'[^a-zA-Z0-9_]', '_', name)
        # Ensure it doesn't start with a number
        if name and name[0].isdigit():
            name = f"field_{name}"
        return name
    
    def _get_sqlalchemy_type(self, field: FieldSchema) -> str:
        """Get SQLAlchemy column type for field"""
        type_mapping = {
            'string': 'String(255)',
            'integer': 'Integer',
            'decimal': 'Float',
            'boolean': 'Boolean',
            'datetime': 'DateTime',
            'object': 'JSON',
            'array': 'JSON'
        }
        
        return type_mapping.get(field.field_type, 'String(255)')

class DynamicEntityWizard:
    """Dynamic entity wizard for any API documentation"""
    
    def __init__(self, table_prefix: str = ""):
        self.table_prefix = table_prefix
        self.parser = DynamicAPIParser()
        self.mysql_generator = MySQLTableGenerator(table_prefix)
        self.model_generator = SQLAlchemyModelGenerator(table_prefix)
        self.discovered_apis = {}
    
    def discover_api(self, api_url: str) -> APIDiscoveryResult:
        """Discover API entities from documentation URL"""
        logger.info(f"Discovering API from: {api_url}")
        
        # Check cache first
        if api_url in self.discovered_apis:
            return self.discovered_apis[api_url]
        
        # Perform discovery
        result = self.parser.discover_entities(api_url)
        
        # Cache result
        self.discovered_apis[api_url] = result
        
        return result
    
    def process_api_url(self, url: str) -> Dict[str, Any]:
        """Process API URL and return generated SQL and Python code"""
        try:
            # Parse the entity schema
            schema = self.parser.parse_entity_schema(url)
            
            # Generate MySQL table
            mysql_table = self.mysql_generator.generate_create_table(schema)
            
            # Generate SQLAlchemy model
            sqlalchemy_model = self.model_generator.generate_model_class(schema)
            
            return {
                'entity_name': schema.name,
                'description': schema.description,
                'endpoint': schema.endpoint,
                'methods': schema.methods,
                'mysql_table': mysql_table,
                'sqlalchemy_model': sqlalchemy_model,
                'schema': schema
            }
            
        except Exception as e:
            logger.error(f"Error processing URL {url}: {e}")
            raise
    
    def generate_all_entities_from_discovery(self, discovery_result: APIDiscoveryResult) -> Dict[str, Any]:
        """Generate SQL and models for all discovered entities"""
        results = {}
        
        for entity in discovery_result.entities:
            try:
                result = self.process_api_url(entity.url)
                results[entity.name] = {
                    'mysql_table': result['mysql_table'],
                    'sqlalchemy_model': result['sqlalchemy_model'],
                    'description': entity.description,
                    'category': entity.category,
                    'endpoint': entity.endpoint,
                    'methods': entity.methods
                }
                logger.info(f"Generated SQL for {entity.name}")
            except Exception as e:
                logger.error(f"Failed to generate SQL for {entity.name}: {e}")
                results[entity.name] = {
                    'error': str(e),
                    'entity_info': entity
                }
        
        return results
    
    def generate_full_integration_package(self, api_url: str) -> Dict[str, Any]:
        """Generate complete integration package for an API"""
        try:
            # Discover the API
            discovery_result = self.discover_api(api_url)
            
            # Generate entities
            entities_result = self.generate_all_entities_from_discovery(discovery_result)
            
            # Create summary
            summary = {
                'api_info': {
                    'name': discovery_result.api_name,
                    'base_url': discovery_result.base_url,
                    'version': discovery_result.version,
                    'total_entities': len(discovery_result.entities),
                    'categories': discovery_result.categories,
                    'authentication_type': discovery_result.authentication_type,
                    'rate_limits': discovery_result.rate_limits
                },
                'entities': entities_result,
                'statistics': {
                    'successful_entities': len([e for e in entities_result.values() if 'error' not in e]),
                    'failed_entities': len([e for e in entities_result.values() if 'error' in e]),
                    'categories_covered': len(set(e.get('category', '') for e in entities_result.values() if 'error' not in e))
                }
            }
            
            return summary
            
        except Exception as e:
            logger.error(f"Error generating integration package: {e}")
            raise
    
    def export_integration_files(self, api_url: str, output_dir: str = "."):
        """Export integration files to directory"""
        import os
        
        try:
            # Generate integration package
            package = self.generate_full_integration_package(api_url)
            
            api_name = package['api_info']['name'].lower()
            
            # Create SQL file
            sql_file = os.path.join(output_dir, f"{api_name}_tables.sql")
            with open(sql_file, 'w') as f:
                f.write(f"-- {package['api_info']['name']} API Tables\n")
                f.write(f"-- Generated from: {api_url}\n")
                f.write(f"-- Total entities: {package['api_info']['total_entities']}\n\n")
                
                for entity_name, entity_data in package['entities'].items():
                    if 'mysql_table' in entity_data:
                        f.write(f"-- {entity_name} ({entity_data.get('category', 'Unknown')})\n")
                        f.write(entity_data['mysql_table'])
                        f.write("\n\n")
            
            # Create Python models file
            models_file = os.path.join(output_dir, f"{api_name}_models.py")
            with open(models_file, 'w') as f:
                f.write(f'"""\n{package["api_info"]["name"]} API SQLAlchemy Models\n')
                f.write(f'Generated from: {api_url}\n')
                f.write(f'Total entities: {package["api_info"]["total_entities"]}\n"""\n\n')
                
                f.write("from sqlalchemy import Column, Integer, String, DateTime, Boolean, Float, JSON\n")
                f.write("from sqlalchemy.ext.declarative import declarative_base\n")
                f.write("from datetime import datetime\n\n")
                f.write("Base = declarative_base()\n\n")
                
                for entity_name, entity_data in package['entities'].items():
                    if 'sqlalchemy_model' in entity_data:
                        f.write(entity_data['sqlalchemy_model'])
                        f.write("\n\n")
            
            # Create summary file
            summary_file = os.path.join(output_dir, f"{api_name}_integration_summary.json")
            with open(summary_file, 'w') as f:
                import json
                json.dump(package, f, indent=2, default=str)
            
            logger.info(f"Integration files exported to {output_dir}")
            logger.info(f"SQL file: {sql_file}")
            logger.info(f"Models file: {models_file}")
            logger.info(f"Summary file: {summary_file}")
            
            return {
                'sql_file': sql_file,
                'models_file': models_file,
                'summary_file': summary_file,
                'package': package
            }
            
        except Exception as e:
            logger.error(f"Error exporting integration files: {e}")
            raise

def main():
    """Main function for command-line usage"""
    import sys
    import argparse
    
    parser = argparse.ArgumentParser(description='Dynamic API Integration Entity Generator')
    parser.add_argument('url', help='API documentation URL')
    parser.add_argument('--discover', action='store_true', help='Discover all entities from API')
    parser.add_argument('--generate-all', action='store_true', help='Generate SQL for all discovered entities')
    parser.add_argument('--export', help='Export integration files to directory')
    parser.add_argument('--table-prefix', default='', help='Table prefix for generated tables')
    
    if len(sys.argv) < 2:
        parser.print_help()
        sys.exit(1)
    
    args = parser.parse_args()
    
    wizard = DynamicEntityWizard(table_prefix=args.table_prefix)
    
    try:
        if args.discover:
            # Discover API entities
            result = wizard.discover_api(args.url)
            print(f"\n=== API Discovery Results ===")
            print(f"API Name: {result.api_name}")
            print(f"Base URL: {result.base_url}")
            print(f"Version: {result.version}")
            print(f"Total Entities: {len(result.entities)}")
            print(f"Categories: {', '.join(result.categories)}")
            
            print(f"\n=== Entities by Category ===")
            for category in result.categories:
                category_entities = [e for e in result.entities if e.category == category]
                print(f"\n{category} ({len(category_entities)} entities):")
                for entity in category_entities:
                    print(f"  - {entity.name}: {entity.description}")
                    print(f"    URL: {entity.url}")
                    if entity.methods:
                        print(f"    Methods: {', '.join(entity.methods)}")
                    if entity.endpoint:
                        print(f"    Endpoint: {entity.endpoint}")
        
        elif args.generate_all:
            # Generate all entities
            result = wizard.discover_api(args.url)
            entities = wizard.generate_all_entities_from_discovery(result)
            
            print(f"\n=== Generated Entities ===")
            successful = 0
            failed = 0
            
            for entity_name, entity_data in entities.items():
                if 'error' in entity_data:
                    print(f"❌ {entity_name}: {entity_data['error']}")
                    failed += 1
                else:
                    print(f"✅ {entity_name} ({entity_data.get('category', 'Unknown')})")
                    successful += 1
            
            print(f"\n=== Summary ===")
            print(f"Successful: {successful}")
            print(f"Failed: {failed}")
            print(f"Total: {successful + failed}")
        
        elif args.export:
            # Export integration files
            result = wizard.export_integration_files(args.url, args.export)
            print(f"\n=== Integration Files Exported ===")
            print(f"SQL File: {result['sql_file']}")
            print(f"Models File: {result['models_file']}")
            print(f"Summary File: {result['summary_file']}")
            
            package = result['package']
            print(f"\n=== Package Summary ===")
            print(f"API: {package['api_info']['name']}")
            print(f"Total Entities: {package['api_info']['total_entities']}")
            print(f"Successful: {package['statistics']['successful_entities']}")
            print(f"Failed: {package['statistics']['failed_entities']}")
            print(f"Categories: {package['statistics']['categories_covered']}")
        
        else:
            # Process single URL
            result = wizard.process_api_url(args.url)
            
            print("=== Entity Information ===")
            print(f"Name: {result['entity_name']}")
            print(f"Description: {result['description']}")
            print(f"Endpoint: {result['endpoint']}")
            print(f"Methods: {', '.join(result['methods'])}")
            print()
            
            print("=== MySQL Table ===")
            print(result['mysql_table'])
            print()
            
            print("=== SQLAlchemy Model ===")
            print(result['sqlalchemy_model'])
    
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()