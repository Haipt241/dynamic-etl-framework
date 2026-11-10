
import requests
import re
import json
from typing import Dict, List, Optional, Tuple, Any
from dataclasses import dataclass, field
from urllib.parse import urlparse, urljoin
from bs4 import BeautifulSoup
import logging
from sqlalchemy import Column, Integer, String, Text, DateTime, Boolean, Float, JSON
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

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

@dataclass
class EntityInfo:
    """Represents basic entity information"""
    name: str
    url: str
    description: str = ""
    category: str = ""

@dataclass
class EntitySchema:
    """Represents an entity schema from API documentation"""
    name: str
    fields: List[FieldSchema] = field(default_factory=list)
    description: str = ""
    table_name: str = ""
    
    def __post_init__(self):
        if not self.table_name:
            self.table_name = self.name.lower()

class APIDocumentationParser:
    """Base class for parsing API documentation"""
    
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
    
    def fetch_page(self, url: str) -> str:
        """Fetch a web page and return its content"""
        try:
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            return response.text
        except requests.RequestException as e:
            logger.error(f"Error fetching {url}: {e}")
            raise
    
    def parse_entity_schema(self, url: str) -> EntitySchema:
        """Parse entity schema from API documentation URL"""
        raise NotImplementedError("Subclasses must implement parse_entity_schema")

class QuickBooksAPIParser(APIDocumentationParser):
    """Parser for QuickBooks Online API documentation"""
    
    def __init__(self):
        super().__init__()
        self.base_url = "https://developer.intuit.com"
        self.qbo_entities = self._get_qbo_entities_list()
    
    def _get_qbo_entities_list(self) -> List[EntityInfo]:
        """Get comprehensive list of QuickBooks Online entities"""
        return [
            EntityInfo("Account", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/account", "Chart of accounts", "Core"),
            EntityInfo("Customer", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/customer", "Customer information", "Core"),
            EntityInfo("Vendor", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/vendor", "Vendor information", "Core"),
            EntityInfo("Employee", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/employee", "Employee information", "Core"),
            EntityInfo("Item", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/item", "Products and services", "Core"),
            EntityInfo("Invoice", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/invoice", "Customer invoices", "Transaction"),
            EntityInfo("Bill", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/bill", "Vendor bills", "Transaction"),
            EntityInfo("Payment", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/payment", "Customer payments", "Transaction"),
            EntityInfo("BillPayment", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/billpayment", "Vendor payments", "Transaction"),
            EntityInfo("Purchase", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/purchase", "Purchase transactions", "Transaction"),
            EntityInfo("SalesReceipt", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/salesreceipt", "Sales receipts", "Transaction"),
            EntityInfo("CreditMemo", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/creditmemo", "Credit memos", "Transaction"),
            EntityInfo("VendorCredit", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/vendorcredit", "Vendor credits", "Transaction"),
            EntityInfo("Estimate", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/estimate", "Customer estimates", "Transaction"),
            EntityInfo("PurchaseOrder", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/purchaseorder", "Purchase orders", "Transaction"),
            EntityInfo("JournalEntry", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/journalentry", "Journal entries", "Transaction"),
            EntityInfo("Transfer", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/transfer", "Transfer transactions", "Transaction"),
            EntityInfo("Deposit", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/deposit", "Bank deposits", "Transaction"),
            EntityInfo("RefundReceipt", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/refundreceipt", "Refund receipts", "Transaction"),
            EntityInfo("TimeActivity", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/timeactivity", "Time tracking", "Transaction"),
            EntityInfo("Class", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/class", "Transaction classes", "Reference"),
            EntityInfo("Department", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/department", "Departments", "Reference"),
            EntityInfo("TaxCode", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/taxcode", "Tax codes", "Reference"),
            EntityInfo("TaxRate", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/taxrate", "Tax rates", "Reference"),
            EntityInfo("PaymentMethod", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/paymentmethod", "Payment methods", "Reference"),
            EntityInfo("Term", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/term", "Payment terms", "Reference"),
            EntityInfo("CompanyInfo", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/companyinfo", "Company information", "Reference"),
            EntityInfo("Preferences", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/preferences", "Company preferences", "Reference"),
            EntityInfo("TaxAgency", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/taxagency", "Tax agencies", "Reference"),
            EntityInfo("TaxService", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/taxservice", "Tax services", "Reference"),
            EntityInfo("ExchangeRate", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/exchangerate", "Currency exchange rates", "Reference"),
            EntityInfo("Budget", "https://developer.intunit.com/app/developer/qbo/docs/api/accounting/all-entities/budget", "Budget information", "Reference"),
            # Report entities
            EntityInfo("BalanceSheet", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/balancesheet", "Balance sheet report", "Report"),
            EntityInfo("ProfitAndLoss", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/profitandloss", "Profit and loss report", "Report"),
            EntityInfo("CashFlow", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/cashflow", "Cash flow report", "Report"),
            EntityInfo("TrialBalance", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/trialbalance", "Trial balance report", "Report"),
            EntityInfo("GeneralLedger", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/generalledger", "General ledger report", "Report"),
            EntityInfo("CustomerBalance", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/customerbalance", "Customer balance report", "Report"),
            EntityInfo("VendorBalance", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/vendorbalance", "Vendor balance report", "Report"),
            EntityInfo("AgedReceivables", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/agedreceivables", "Aged receivables report", "Report"),
            EntityInfo("AgedPayables", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/agedpayables", "Aged payables report", "Report"),
            EntityInfo("CustomerIncome", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/customerincome", "Customer income report", "Report"),
            EntityInfo("VendorExpenses", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/vendorexpenses", "Vendor expenses report", "Report"),
            EntityInfo("ItemSales", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/itemsales", "Item sales report", "Report"),
            EntityInfo("TaxSummary", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/taxsummary", "Tax summary report", "Report"),
            EntityInfo("AccountListDetailReport", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/accountlistdetailreport", "Account list detail report", "Report"),
            EntityInfo("CustomerListDetailReport", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/customerlistdetailreport", "Customer list detail report", "Report"),
            EntityInfo("VendorListDetailReport", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/vendorlistdetailreport", "Vendor list detail report", "Report"),
            EntityInfo("ItemListDetailReport", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/itemlistdetailreport", "Item list detail report", "Report"),
            EntityInfo("EmployeeListDetailReport", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/employeelistdetailreport", "Employee list detail report", "Report"),
            EntityInfo("APAgingDetailReport", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/apagingdetailreport", "AP aging detail report", "Report"),
            EntityInfo("ARAgingDetailReport", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/aragingdetailreport", "AR aging detail report", "Report"),
            EntityInfo("TransactionListReport", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/transactionlistreport", "Transaction list report", "Report"),
            EntityInfo("JournalReport", "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/reports/journalreport", "Journal report", "Report"),
        ]
    
    def get_all_entities(self) -> List[EntityInfo]:
        """Get list of all available QuickBooks Online entities"""
        return self.qbo_entities
    
    def get_entities_by_category(self, category: str) -> List[EntityInfo]:
        """Get entities filtered by category"""
        return [entity for entity in self.qbo_entities if entity.category.lower() == category.lower()]
    
    def parse_entity_schema(self, url: str) -> EntitySchema:
        """Parse QuickBooks API entity schema from documentation URL"""
        content = self.fetch_page(url)
        soup = BeautifulSoup(content, 'html.parser')
        
        # Extract entity name from URL
        entity_name = self._extract_entity_name(url)
        
        # Parse fields from the documentation
        fields = self._parse_fields_from_content(soup)
        
        # Get entity description
        description = self._extract_description(soup)
        
        return EntitySchema(
            name=entity_name,
            fields=fields,
            description=description
        )
    
    def _extract_entity_name(self, url: str) -> str:
        """Extract entity name from URL"""
        # Extract from URL like: .../all-entities/account
        parts = url.split('/')
        if 'all-entities' in parts:
            idx = parts.index('all-entities')
            if idx + 1 < len(parts):
                return parts[idx + 1].title()
        return "Unknown"
    
    def _parse_fields_from_content(self, soup: BeautifulSoup) -> List[FieldSchema]:
        """Parse fields from BeautifulSoup content"""
        fields = []
        
        # Look for tables with field definitions
        tables = soup.find_all('table')
        for table in tables:
            fields.extend(self._parse_table_fields(table))
        
        # Look for JSON schema examples
        code_blocks = soup.find_all('code')
        for code in code_blocks:
            if 'json' in code.get('class', []):
                fields.extend(self._parse_json_schema(code.text))
        
        return fields
    
    def _parse_table_fields(self, table) -> List[FieldSchema]:
        """Parse fields from HTML table"""
        fields = []
        rows = table.find_all('tr')
        
        for row in rows[1:]:  # Skip header row
            cells = row.find_all(['td', 'th'])
            if len(cells) >= 2:
                field_name = cells[0].get_text(strip=True)
                field_type = cells[1].get_text(strip=True)
                description = cells[2].get_text(strip=True) if len(cells) > 2 else ""
                
                fields.append(FieldSchema(
                    name=field_name,
                    field_type=self._normalize_type(field_type),
                    description=description
                ))
        
        return fields
    
    def _parse_json_schema(self, json_text: str) -> List[FieldSchema]:
        """Parse fields from JSON schema example"""
        fields = []
        try:
            data = json.loads(json_text)
            fields = self._extract_fields_from_json(data)
        except json.JSONDecodeError:
            logger.warning("Could not parse JSON schema")
        
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
    
    def _normalize_type(self, type_str: str) -> str:
        """Normalize field type string"""
        type_str = type_str.lower().strip()
        
        type_mapping = {
            'string': 'string',
            'text': 'string',
            'integer': 'integer',
            'int': 'integer',
            'decimal': 'decimal',
            'float': 'decimal',
            'boolean': 'boolean',
            'bool': 'boolean',
            'date': 'datetime',
            'datetime': 'datetime',
            'timestamp': 'datetime',
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
            return 'string'
        else:
            return 'string'
    
    def _extract_description(self, soup: BeautifulSoup) -> str:
        """Extract entity description from documentation"""
        # Look for description in various places
        desc_selectors = [
            'p.description',
            '.entity-description',
            'div.overview p',
            'h1 + p'
        ]
        
        for selector in desc_selectors:
            element = soup.select_one(selector)
            if element:
                return element.get_text(strip=True)
        
        return ""

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
            "etl_batch_id VARCHAR(100)"
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
            "etl_batch_id = Column(String(100))"
        ])
        
        model_class = f'''
class {class_name}(Base):
    """
    {schema.description}
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

class EntityWizard:
    """Main wizard class for processing API URLs and generating entities"""
    
    def __init__(self, table_prefix: str = ""):
        self.table_prefix = table_prefix
        self.parsers = {
            'developer.intuit.com': QuickBooksAPIParser(),
        }
        self.mysql_generator = MySQLTableGenerator(table_prefix)
        self.model_generator = SQLAlchemyModelGenerator(table_prefix)
    
    def process_api_url(self, url: str) -> Dict[str, str]:
        """Process API URL and return generated SQL and Python code"""
        try:
            # Determine which parser to use
            parser = self._get_parser_for_url(url)
            
            # Parse the entity schema
            schema = parser.parse_entity_schema(url)
            
            # Generate MySQL table
            mysql_table = self.mysql_generator.generate_create_table(schema)
            
            # Generate SQLAlchemy model
            sqlalchemy_model = self.model_generator.generate_model_class(schema)
            
            return {
                'entity_name': schema.name,
                'description': schema.description,
                'mysql_table': mysql_table,
                'sqlalchemy_model': sqlalchemy_model,
                'schema': schema
            }
            
        except Exception as e:
            logger.error(f"Error processing URL {url}: {e}")
            raise
    
    def _get_parser_for_url(self, url: str) -> APIDocumentationParser:
        """Get appropriate parser for URL"""
        parsed_url = urlparse(url)
        domain = parsed_url.netloc
        
        for domain_pattern, parser in self.parsers.items():
            if domain_pattern in domain:
                return parser
        
        raise ValueError(f"No parser available for domain: {domain}")
    
    def get_available_entities(self, api_type: str = "qbo") -> List[EntityInfo]:
        """Get list of available entities for the specified API type"""
        if api_type.lower() == "qbo":
            parser = self.parsers.get('developer.intuit.com')
            if parser and hasattr(parser, 'get_all_entities'):
                return parser.get_all_entities()
        return []
    
    def get_entities_by_category(self, category: str, api_type: str = "qbo") -> List[EntityInfo]:
        """Get entities filtered by category"""
        if api_type.lower() == "qbo":
            parser = self.parsers.get('developer.intuit.com')
            if parser and hasattr(parser, 'get_entities_by_category'):
                return parser.get_entities_by_category(category)
        return []
    
    def list_entity_categories(self, api_type: str = "qbo") -> List[str]:
        """Get list of available entity categories"""
        entities = self.get_available_entities(api_type)
        categories = list(set(entity.category for entity in entities if entity.category))
        return sorted(categories)
    
    def print_entities_summary(self, api_type: str = "qbo"):
        """Print a summary of available entities organized by category"""
        entities = self.get_available_entities(api_type)
        categories = self.list_entity_categories(api_type)
        
        print(f"\n=== {api_type.upper()} API Entities Summary ===")
        print(f"Total entities: {len(entities)}")
        
        for category in categories:
            category_entities = self.get_entities_by_category(category, api_type)
            print(f"\n{category} ({len(category_entities)} entities):")
            for entity in category_entities:
                print(f"  - {entity.name}: {entity.description}")
    
    def generate_all_entities_sql(self, api_type: str = "qbo", categories: List[str] = None) -> Dict[str, str]:
        """Generate SQL for all entities or specific categories"""
        results = {}
        entities = self.get_available_entities(api_type)
        
        if categories:
            entities = [e for e in entities if e.category in categories]
        
        for entity in entities:
            try:
                result = self.process_api_url(entity.url)
                results[entity.name] = {
                    'mysql_table': result['mysql_table'],
                    'sqlalchemy_model': result['sqlalchemy_model'],
                    'description': entity.description,
                    'category': entity.category
                }
                logger.info(f"Generated SQL for {entity.name}")
            except Exception as e:
                logger.error(f"Failed to generate SQL for {entity.name}: {e}")
                results[entity.name] = {'error': str(e)}
        
        return results
    
    def batch_process_urls(self, urls: List[str]) -> List[Dict[str, str]]:
        """Process multiple URLs in batch"""
        results = []
        
        for url in urls:
            try:
                result = self.process_api_url(url)
                results.append(result)
                logger.info(f"Successfully processed: {url}")
            except Exception as e:
                logger.error(f"Failed to process {url}: {e}")
                results.append({
                    'url': url,
                    'error': str(e)
                })
        
        return results

def main():
    """Main function for command-line usage"""
    import sys
    
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python integration_entities.py <api_url>           - Process single URL")
        print("  python integration_entities.py --list-entities     - List all available entities")
        print("  python integration_entities.py --list-category <category> - List entities by category")
        print("  python integration_entities.py --generate-all      - Generate SQL for all entities")
        print("  python integration_entities.py --generate-category <category> - Generate SQL for category")
        print("\nAvailable categories: Core, Transaction, Reference, Report")
        sys.exit(1)
    
    wizard = EntityWizard()
    command = sys.argv[1]
    
    try:
        if command == "--list-entities":
            wizard.print_entities_summary()
        
        elif command == "--list-category":
            if len(sys.argv) < 3:
                print("Please specify a category: Core, Transaction, Reference, Report")
                sys.exit(1)
            category = sys.argv[2]
            entities = wizard.get_entities_by_category(category)
            print(f"\n=== {category} Entities ===")
            for entity in entities:
                print(f"{entity.name}: {entity.description}")
                print(f"  URL: {entity.url}")
                print()
        
        elif command == "--generate-all":
            print("Generating SQL for all entities...")
            results = wizard.generate_all_entities_sql()
            for name, result in results.items():
                if 'error' in result:
                    print(f"Error generating {name}: {result['error']}")
                else:
                    print(f"\n=== {name} ({result['category']}) ===")
                    print(result['mysql_table'])
                    print()
        
        elif command == "--generate-category":
            if len(sys.argv) < 3:
                print("Please specify a category: Core, Transaction, Reference, Report")
                sys.exit(1)
            category = sys.argv[2]
            print(f"Generating SQL for {category} entities...")
            results = wizard.generate_all_entities_sql(categories=[category])
            for name, result in results.items():
                if 'error' in result:
                    print(f"Error generating {name}: {result['error']}")
                else:
                    print(f"\n=== {name} ===")
                    print(result['mysql_table'])
                    print()
        
        else:
            # Process single URL
            url = sys.argv[1]
            result = wizard.process_api_url(url)
            
            print("=== Entity Information ===")
            print(f"Name: {result['entity_name']}")
            print(f"Description: {result['description']}")
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