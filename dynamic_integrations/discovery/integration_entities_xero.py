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

class XeroAPIParser(APIDocumentationParser):
    """Parser for Xero Accounting API documentation"""
    
    def __init__(self):
        super().__init__()
        self.base_url = "https://developer.xero.com"
        self.xero_entities = self._get_xero_entities_list()
    
    def _get_xero_entities_list(self) -> List[EntityInfo]:
        """Get comprehensive list of Xero Accounting API entities"""
        return [
            # Core Accounting Entities
            EntityInfo("Account", "https://developer.xero.com/documentation/api/accounting/accounts", "Chart of accounts", "Core"),
            EntityInfo("Contact", "https://developer.xero.com/documentation/api/accounting/contacts", "Contacts (customers and suppliers)", "Core"),
            EntityInfo("Item", "https://developer.xero.com/documentation/api/accounting/items", "Products and services", "Core"),
            EntityInfo("Organisation", "https://developer.xero.com/documentation/api/accounting/organisation", "Organisation information", "Core"),
            EntityInfo("User", "https://developer.xero.com/documentation/api/accounting/users", "User information", "Core"),
            EntityInfo("Currency", "https://developer.xero.com/documentation/api/accounting/currencies", "Currency information", "Core"),
            EntityInfo("BrandingTheme", "https://developer.xero.com/documentation/api/accounting/brandingthemes", "Branding themes", "Core"),
            
            # Transaction Entities
            EntityInfo("Invoice", "https://developer.xero.com/documentation/api/accounting/invoices", "Sales invoices", "Transaction"),
            EntityInfo("CreditNote", "https://developer.xero.com/documentation/api/accounting/creditnotes", "Credit notes", "Transaction"),
            EntityInfo("Payment", "https://developer.xero.com/documentation/api/accounting/payments", "Payments", "Transaction"),
            EntityInfo("BankTransaction", "https://developer.xero.com/documentation/api/accounting/banktransactions", "Bank transactions", "Transaction"),
            EntityInfo("ManualJournal", "https://developer.xero.com/documentation/api/accounting/manualjournals", "Manual journals", "Transaction"),
            EntityInfo("Journal", "https://developer.xero.com/documentation/api/accounting/journals", "System journals", "Transaction"),
            EntityInfo("BankTransfer", "https://developer.xero.com/documentation/api/accounting/banktransfers", "Bank transfers", "Transaction"),
            EntityInfo("Overpayment", "https://developer.xero.com/documentation/api/accounting/overpayments", "Overpayments", "Transaction"),
            EntityInfo("Prepayment", "https://developer.xero.com/documentation/api/accounting/prepayments", "Prepayments", "Transaction"),
            EntityInfo("PurchaseOrder", "https://developer.xero.com/documentation/api/accounting/purchaseorders", "Purchase orders", "Transaction"),
            EntityInfo("Receipt", "https://developer.xero.com/documentation/api/accounting/receipts", "Receipts", "Transaction"),
            EntityInfo("ExpenseClaim", "https://developer.xero.com/documentation/api/accounting/expenseclaims", "Expense claims", "Transaction"),
            EntityInfo("RepeatingInvoice", "https://developer.xero.com/documentation/api/accounting/repeatinginvoices", "Repeating invoices", "Transaction"),
            EntityInfo("Quote", "https://developer.xero.com/documentation/api/accounting/quotes", "Quotes", "Transaction"),
            
            # Reference/Setup Entities
            EntityInfo("TaxRate", "https://developer.xero.com/documentation/api/accounting/taxrates", "Tax rates", "Reference"),
            EntityInfo("TrackingCategory", "https://developer.xero.com/documentation/api/accounting/trackingcategories", "Tracking categories", "Reference"),
            EntityInfo("LinkedTransaction", "https://developer.xero.com/documentation/api/accounting/linkedtransactions", "Linked transactions", "Reference"),
            EntityInfo("Attachment", "https://developer.xero.com/documentation/api/accounting/attachments", "File attachments", "Reference"),
            EntityInfo("PaymentService", "https://developer.xero.com/documentation/api/accounting/paymentservices", "Payment services", "Reference"),
            EntityInfo("HistoryRecord", "https://developer.xero.com/documentation/api/accounting/history", "History records", "Reference"),
            EntityInfo("Setup", "https://developer.xero.com/documentation/api/accounting/setup", "Setup information", "Reference"),
            EntityInfo("BatchPayment", "https://developer.xero.com/documentation/api/accounting/batchpayments", "Batch payments", "Reference"),
            
            # Report Entities
            EntityInfo("BalanceSheet", "https://developer.xero.com/documentation/api/accounting/reports/balancesheet", "Balance sheet report", "Report"),
            EntityInfo("ProfitAndLoss", "https://developer.xero.com/documentation/api/accounting/reports/profitandloss", "Profit and loss report", "Report"),
            EntityInfo("CashFlow", "https://developer.xero.com/documentation/api/accounting/reports/cashflow", "Cash flow report", "Report"),
            EntityInfo("TrialBalance", "https://developer.xero.com/documentation/api/accounting/reports/trialbalance", "Trial balance report", "Report"),
            EntityInfo("BankStatement", "https://developer.xero.com/documentation/api/accounting/reports/bankstatement", "Bank statement report", "Report"),
            EntityInfo("AgedReceivables", "https://developer.xero.com/documentation/api/accounting/reports/agedreceivables", "Aged receivables report", "Report"),
            EntityInfo("AgedPayables", "https://developer.xero.com/documentation/api/accounting/reports/agedpayables", "Aged payables report", "Report"),
            EntityInfo("TaxReport", "https://developer.xero.com/documentation/api/accounting/reports/taxreport", "Tax report", "Report"),
            EntityInfo("ExecutiveSummary", "https://developer.xero.com/documentation/api/accounting/reports/executivesummary", "Executive summary report", "Report"),
            EntityInfo("BankSummary", "https://developer.xero.com/documentation/api/accounting/reports/banksummary", "Bank summary report", "Report"),
            EntityInfo("BudgetSummary", "https://developer.xero.com/documentation/api/accounting/reports/budgetsummary", "Budget summary report", "Report"),
            EntityInfo("ContactSummary", "https://developer.xero.com/documentation/api/accounting/reports/contactsummary", "Contact summary report", "Report"),
            EntityInfo("AccountSummary", "https://developer.xero.com/documentation/api/accounting/reports/accountsummary", "Account summary report", "Report"),
            EntityInfo("TenNinetyNine", "https://developer.xero.com/documentation/api/accounting/reports/ten99", "Ten Ninety Nine report", "Report"),
            
            # Asset Entities
            EntityInfo("Asset", "https://developer.xero.com/documentation/api/assets/assets", "Fixed assets", "Asset"),
            EntityInfo("AssetType", "https://developer.xero.com/documentation/api/assets/assettypes", "Asset types", "Asset"),
            EntityInfo("AssetSetting", "https://developer.xero.com/documentation/api/assets/settings", "Asset settings", "Asset"),
            
            # Payroll Entities (AU)
            EntityInfo("Employee", "https://developer.xero.com/documentation/api/payrollau/employees", "Employee information (AU)", "Payroll"),
            EntityInfo("PayrollCalendar", "https://developer.xero.com/documentation/api/payrollau/payrollcalendars", "Payroll calendars (AU)", "Payroll"),
            EntityInfo("PayRun", "https://developer.xero.com/documentation/api/payrollau/payruns", "Pay runs (AU)", "Payroll"),
            EntityInfo("Payslip", "https://developer.xero.com/documentation/api/payrollau/payslips", "Payslips (AU)", "Payroll"),
            EntityInfo("LeaveApplication", "https://developer.xero.com/documentation/api/payrollau/leaveapplications", "Leave applications (AU)", "Payroll"),
            EntityInfo("Timesheet", "https://developer.xero.com/documentation/api/payrollau/timesheets", "Timesheets (AU)", "Payroll"),
            EntityInfo("SuperFund", "https://developer.xero.com/documentation/api/payrollau/superfunds", "Super funds (AU)", "Payroll"),
            EntityInfo("PayItem", "https://developer.xero.com/documentation/api/payrollau/payitems", "Pay items (AU)", "Payroll"),
            EntityInfo("PayrollSetting", "https://developer.xero.com/documentation/api/payrollau/settings", "Payroll settings (AU)", "Payroll"),
            
            # Payroll Entities (UK)
            EntityInfo("EmployeeUK", "https://developer.xero.com/documentation/api/payrolluk/employees", "Employee information (UK)", "Payroll"),
            EntityInfo("PayRunUK", "https://developer.xero.com/documentation/api/payrolluk/payruns", "Pay runs (UK)", "Payroll"),
            EntityInfo("PayslipUK", "https://developer.xero.com/documentation/api/payrolluk/payslips", "Payslips (UK)", "Payroll"),
            EntityInfo("TimesheetUK", "https://developer.xero.com/documentation/api/payrolluk/timesheets", "Timesheets (UK)", "Payroll"),
            EntityInfo("BenefitUK", "https://developer.xero.com/documentation/api/payrolluk/benefits", "Benefits (UK)", "Payroll"),
            EntityInfo("DeductionUK", "https://developer.xero.com/documentation/api/payrolluk/deductions", "Deductions (UK)", "Payroll"),
            EntityInfo("EarningsRateUK", "https://developer.xero.com/documentation/api/payrolluk/earningsrates", "Earnings rates (UK)", "Payroll"),
            EntityInfo("LeaveTypeUK", "https://developer.xero.com/documentation/api/payrolluk/leavetypes", "Leave types (UK)", "Payroll"),
            EntityInfo("ReimbursementTypeUK", "https://developer.xero.com/documentation/api/payrolluk/reimbursementtypes", "Reimbursement types (UK)", "Payroll"),
            EntityInfo("PayrollSettingUK", "https://developer.xero.com/documentation/api/payrolluk/settings", "Payroll settings (UK)", "Payroll"),
            EntityInfo("TrackingCategoryUK", "https://developer.xero.com/documentation/api/payrolluk/trackingcategories", "Tracking categories (UK)", "Payroll"),
            
            # Payroll Entities (US)
            EntityInfo("EmployeeUS", "https://developer.xero.com/documentation/api/payrollus/employees", "Employee information (US)", "Payroll"),
            EntityInfo("PayRunUS", "https://developer.xero.com/documentation/api/payrollus/payruns", "Pay runs (US)", "Payroll"),
            EntityInfo("PayslipUS", "https://developer.xero.com/documentation/api/payrollus/payslips", "Payslips (US)", "Payroll"),
            EntityInfo("TimesheetUS", "https://developer.xero.com/documentation/api/payrollus/timesheets", "Timesheets (US)", "Payroll"),
            EntityInfo("PayScheduleUS", "https://developer.xero.com/documentation/api/payrollus/payschedules", "Pay schedules (US)", "Payroll"),
            EntityInfo("PayrollCalendarUS", "https://developer.xero.com/documentation/api/payrollus/payrollcalendars", "Payroll calendars (US)", "Payroll"),
            EntityInfo("PayrollSettingUS", "https://developer.xero.com/documentation/api/payrollus/settings", "Payroll settings (US)", "Payroll"),
            
            # Project Entities
            EntityInfo("Project", "https://developer.xero.com/documentation/api/projects/projects", "Projects", "Project"),
            EntityInfo("ProjectUser", "https://developer.xero.com/documentation/api/projects/projectusers", "Project users", "Project"),
            EntityInfo("Time", "https://developer.xero.com/documentation/api/projects/time", "Time entries", "Project"),
            
            # Files API
            EntityInfo("File", "https://developer.xero.com/documentation/api/files/files", "Files", "File"),
            EntityInfo("Folder", "https://developer.xero.com/documentation/api/files/folders", "Folders", "File"),
            EntityInfo("Inbox", "https://developer.xero.com/documentation/api/files/inbox", "Inbox", "File"),
            EntityInfo("Association", "https://developer.xero.com/documentation/api/files/associations", "File associations", "File"),
            
            # Bank Feeds API
            EntityInfo("FeedConnection", "https://developer.xero.com/documentation/api/bank-feeds/feedconnections", "Feed connections", "BankFeed"),
            EntityInfo("Statement", "https://developer.xero.com/documentation/api/bank-feeds/statements", "Bank feed statements", "BankFeed"),
        ]
    
    def get_all_entities(self) -> List[EntityInfo]:
        """Get list of all available Xero entities"""
        return self.xero_entities
    
    def get_entities_by_category(self, category: str) -> List[EntityInfo]:
        """Get entities filtered by category"""
        return [entity for entity in self.xero_entities if entity.category.lower() == category.lower()]
    
    def parse_entity_schema(self, url: str) -> EntitySchema:
        """Parse Xero API entity schema from documentation URL"""
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
        # Extract from URL like: .../api/accounting/accounts
        parts = url.split('/')
        if 'api' in parts and 'accounting' in parts:
            try:
                idx = parts.index('accounting')
                if idx + 1 < len(parts):
                    return parts[idx + 1].title()
            except ValueError:
                pass
        elif 'api' in parts:
            try:
                idx = parts.index('api')
                if idx + 2 < len(parts):
                    return parts[idx + 2].title()
            except ValueError:
                pass
        
        # Fallback to last part of URL
        return parts[-1].title() if parts else "Unknown"
    
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
            try:
                if 'json' in code.get('class', []) or '{' in code.text:
                    fields.extend(self._parse_json_schema(code.text))
            except:
                continue
        
        # Look for pre blocks with JSON
        pre_blocks = soup.find_all('pre')
        for pre in pre_blocks:
            try:
                if '{' in pre.text:
                    fields.extend(self._parse_json_schema(pre.text))
            except:
                continue
        
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
                
                # Skip empty or header rows
                if not field_name or field_name.lower() in ['name', 'field', 'parameter', 'property']:
                    continue
                
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
            # Clean the JSON text
            json_text = json_text.strip()
            if not json_text.startswith('{') and not json_text.startswith('['):
                # Try to extract JSON from text
                start = json_text.find('{')
                end = json_text.rfind('}')
                if start != -1 and end != -1:
                    json_text = json_text[start:end+1]
            
            # Try to parse as JSON
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
                        if field_name and not field_name.startswith('{') and not field_name.startswith('['):
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
    
    def _normalize_type(self, type_str: str) -> str:
        """Normalize field type string"""
        type_str = type_str.lower().strip()
        
        type_mapping = {
            'string': 'string',
            'text': 'string',
            'integer': 'integer',
            'int': 'integer',
            'number': 'decimal',
            'decimal': 'decimal',
            'float': 'decimal',
            'double': 'decimal',
            'boolean': 'boolean',
            'bool': 'boolean',
            'date': 'datetime',
            'datetime': 'datetime',
            'timestamp': 'datetime',
            'guid': 'string',
            'uuid': 'string',
            'enum': 'string',
            'array': 'array',
            'object': 'object',
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
            if 'T' in value and ('Z' in value or '+' in value):
                return 'datetime'
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
            'h1 + p',
            '.lead',
            'article p:first-of-type',
            'main p:first-of-type'
        ]
        
        for selector in desc_selectors:
            element = soup.select_one(selector)
            if element:
                desc = element.get_text(strip=True)
                if len(desc) > 20:  # Skip very short descriptions
                    return desc
        
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
            "tenant_id VARCHAR(50)",
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
            "tenant_id = Column(String(50))",
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

class XeroEntityWizard:
    """Main wizard class for processing Xero API URLs and generating entities"""
    
    def __init__(self, table_prefix: str = ""):
        self.table_prefix = table_prefix
        self.parsers = {
            'developer.xero.com': XeroAPIParser(),
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
    
    def get_available_entities(self, api_type: str = "xero") -> List[EntityInfo]:
        """Get list of available entities for the specified API type"""
        if api_type.lower() == "xero":
            parser = self.parsers.get('developer.xero.com')
            if parser and hasattr(parser, 'get_all_entities'):
                return parser.get_all_entities()
        return []
    
    def get_entities_by_category(self, category: str, api_type: str = "xero") -> List[EntityInfo]:
        """Get entities filtered by category"""
        if api_type.lower() == "xero":
            parser = self.parsers.get('developer.xero.com')
            if parser and hasattr(parser, 'get_entities_by_category'):
                return parser.get_entities_by_category(category)
        return []
    
    def list_entity_categories(self, api_type: str = "xero") -> List[str]:
        """Get list of available entity categories"""
        entities = self.get_available_entities(api_type)
        categories = list(set(entity.category for entity in entities if entity.category))
        return sorted(categories)
    
    def print_entities_summary(self, api_type: str = "xero"):
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
    
    def generate_all_entities_sql(self, api_type: str = "xero", categories: List[str] = None) -> Dict[str, str]:
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
        print("  python integration_entities_xero.py <api_url>           - Process single URL")
        print("  python integration_entities_xero.py --list-entities     - List all available entities")
        print("  python integration_entities_xero.py --list-category <category> - List entities by category")
        print("  python integration_entities_xero.py --generate-all      - Generate SQL for all entities")
        print("  python integration_entities_xero.py --generate-category <category> - Generate SQL for category")
        print("\nAvailable categories: Core, Transaction, Reference, Report, Asset, Payroll, Project, File, BankFeed")
        sys.exit(1)
    
    wizard = XeroEntityWizard()
    command = sys.argv[1]
    
    try:
        if command == "--list-entities":
            wizard.print_entities_summary()
        
        elif command == "--list-category":
            if len(sys.argv) < 3:
                print("Please specify a category: Core, Transaction, Reference, Report, Asset, Payroll, Project, File, BankFeed")
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
                print("Please specify a category: Core, Transaction, Reference, Report, Asset, Payroll, Project, File, BankFeed")
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