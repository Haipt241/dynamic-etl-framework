# S3 Token Management và OAuth Refresh Logic

**Branch:** `xero-aws-only`
**Files:** `s3_upload_tool.py`, `s3_token_manager.py`, `XEROBLUE - UPSERT.py`

---

## 1. S3 TOKEN STORAGE PATTERNS

### Core Files
- `s3_upload_tool.py` - S3 operations wrapper
- `s3_token_manager.py` - OAuth token management with S3 storage

### Key Architecture
- **Bucket:** `vibecfo-bucket`
- **Token Prefix:** `xerobluetokens/`
- **Token Format:** `{CLIENT_ID}_{ORG_ID}.txt` (JSON content)
- **Backup Strategy:** Single backup per token (`.backup_latest` - not timestamped)

### Token File Structure
```json
{
  "access_token": "REDACTED",
  "refresh_token": "REDACTED",
  "expires_in": 1800,
  "token_type": "Bearer"
}
```

### S3 Operations Pattern
```python
class S3Uploader:
    def __init__(self, bucket_name="vibecfo-bucket", region_name="us-east-1"):
        self.s3_client = boto3.client('s3', region_name=region_name)
        # Test credentials immediately
        self.s3_client.head_bucket(Bucket=bucket_name)

    def update_file(self, s3_key, contents, backup=True):
        # Create single backup before updating
        if backup:
            backup_key = f"{s3_key}.backup_latest"
            self.s3_client.copy_object(..t.)

        return self.write_file(s3_key, contents)
```

### Retry Logic for S3
- **Pattern:** Uses `tenacity` library with exponential backoff
- **Retries:** 3 attempts with 2s, 4s, 8s delays
- **Target Errors:** `ClientError` from boto3

---

## 2. OAUTH 30-MINUTE ACCESS TOKEN PATTERN

### Core Architecture
- **Access Token Lifetime:** 30 minutes (1800 seconds) - Xero specific
- **Refresh Buffer:** 5 minutes (300 seconds) before expiration
- **Token Caching:** In-memory caching to avoid unnecessary refreshes
- **Distributed Locking:** Prevents race conditions across ECS containers

### Token Caching Implementation
```python
class XeroAPI:
    def __init__(self):
        self.cached_access_token = None
        self.cached_refresh_token = None
        self.token_expires_at = None  # Unix timestamp
        self.token_filename = None

    def xero_requests(self, endpoint, ...):
        current_time = time.time()

        # Check if refresh needed (5 minute buffer)
        token_needs_refresh = (
            self.cached_access_token is None or
            self.token_filename != TokenFileName or
            self.token_expires_at is None or
            current_time >= (self.token_expires_at - 300)
        )

        if token_needs_refresh:
            # Refresh and cache token
            self.cached_access_token = new_access_token
            self.token_expires_at = current_time + 1800  # 30 minutes
            print("✓ Token refreshed and cached (expires in 30 minutes)")
        else:
            remaining_minutes = int((self.token_expires_at - current_time) / 60)
            print(f"✓ Using cached token (expires in {remaining_minutes} minutes)")
```

### Distributed Locking Pattern
```python
# File: token_lock_manager.py
class TokenLockManager:
    # Uses DynamoDB for distributed locking
    # Prevents multiple containers from refreshing same token simultaneously

# Usage in s3_token_manager.py
def get_new_token(self, refresh_token, token_filename, max_lock_attempts=3):
    for attempt in range(1, max_lock_attempts + 1):
        try:
            with self.lock_manager.lock(token_filename, wait=True):
                return self._do_token_refresh(...)
        except RuntimeError:
            # Lock timeout - retry with 10s delay
            time.sleep(10)
```

### CMS Database Fallback Pattern
- **Trigger:** 400 Bad Request on token refresh
- **Action:** Retrieve fresh `RefreshToken` from CMS database
- **Prevention:** `retry_with_cms=False` prevents infinite recursion
- **Use Case:** UI token refresh newer than S3 stored token

---

## 3. ERROR CLASSIFICATION AND HANDLING

### Error Categories
```python
def classify_xero_error(status_code: int, response_body: dict = None):
    """
    Returns error classification:
    - TOKEN_FAILURE: User must reconnect (set status 13)
    - RATE_LIMITED: Hit daily limit (checkpoint saved)
    - SERVER_ERROR: Xero issue (checkpoint saved, set status 1)
    - DATA_ERROR: Validation error (log and continue)
    """

    if status_code == 401:
        if 'TokenExpired' in detail:
            return 'TOKEN_FAILURE'  # After retry failed
        return 'DATA_ERROR'  # Permission issue

    if status_code == 403:
        return 'TOKEN_FAILURE'  # Authorization revoked

    if status_code == 429:
        return 'RATE_LIMITED'  # Daily API limit

    if status_code in [500, 503]:
        return 'SERVER_ERROR'  # Xero server issue

    return 'DATA_ERROR'  # 400, 404, 409, etc.
```

### Checkpoint Recovery Pattern
- **File:** `etl_checkpoint.py`
- **Purpose:** Handle rate limit (429) recovery
- **Strategy:** Save last processed endpoint + last refresh date
- **Recovery:** Resume from checkpoint after 24h wait

---

## 4. ADAPTATION FOR OTHER INTEGRATIONS (TOKEN PATTERNS)

### MYOB Token Adaptations
```python
# MYOB-specific token changes:
MYOB_TOKEN_ENDPOINT = "https://secure.myob.com/oauth2/v1/authorize"
MYOB_ACCESS_TOKEN_LIFETIME = 3600  # 1 hour (check docs)

# S3 token structure
MYOB_TOKEN_PREFIX = "myobtokens/"
MYOB_TOKEN_FORMAT = "{CLIENT_ID}_{COMPANY_FILE_ID}.txt"

# Apply same 30-minute caching pattern but with 1-hour lifetime
# Change: self.token_expires_at = current_time + 3600  # 1 hour
# Change: current_time >= (self.token_expires_at - 300)  # 5-min buffer
```

### QBO (QuickBooks Online) Token Adaptations
```python
# QBO-specific token changes:
QBO_TOKEN_ENDPOINT = "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"
QBO_ACCESS_TOKEN_LIFETIME = 3600  # 1 hour

# S3 token structure
QBO_TOKEN_PREFIX = "qbotokens/"
QBO_TOKEN_FORMAT = "{CLIENT_ID}_{REALM_ID}.txt"

# Apply same caching pattern with 1-hour lifetime
# Change: self.token_expires_at = current_time + 3600  # 1 hour
```

### Generic Token Config Pattern
```python
class TokenConfig:
    def __init__(self, provider):
        self.provider = provider
        self.token_endpoint = self.get_token_endpoint()
        self.access_token_lifetime = self.get_token_lifetime()
        self.s3_prefix = f"{provider.lower()}tokens/"
        self.token_format = self.get_token_format()

    # Override per integration
    def get_token_endpoint(self): pass
    def get_token_lifetime(self): pass  # 1800 for Xero, 3600 for MYOB/QBO
    def get_token_format(self): pass    # File naming pattern
```

---

## 5. REUSABLE TOKEN COMPONENTS

### Components Dùng Cho Tất Cả Integrations
1. **S3Uploader** - Generic S3 operations với retry logic
2. **TokenLockManager** - Distributed locking cho bất kỳ OAuth provider nào
3. **30-minute caching pattern** - Chỉ cần thay đổi token lifetime value
4. **CMS fallback mechanism** - Reusable cho tất cả integrations

### Components Cần Adaptation
1. **Token refresh endpoint URLs**
2. **Access token lifetime values** (1800s vs 3600s)
3. **S3 token prefix và file naming format**
4. **Client credentials và authorization headers**

---

## 6. IMPLEMENTATION CHECKLIST CHO TOKEN LOGIC

### Cho Integration Mới (MYOB/QBO)
- [ ] Tạo integration-specific token config class
- [ ] Adapt token endpoint URLs
- [ ] Update access token lifetime values (1800s → 3600s)
- [ ] Update S3 token prefix và file naming format
- [ ] Test distributed locking với token files mới
- [ ] Test CMS fallback mechanism
- [ ] Update client credentials (CLIENT_ID, CLIENT_SECRET)

### Testing Strategy Cho Token Logic
1. Test token refresh với expired tokens
2. Test CMS fallback mechanism khi S3 token outdated
3. Test distributed locking under high concurrency (multiple containers)
4. Test token caching performance (ensure không refresh mỗi API call)
5. Validate error classification cho token failures
6. Test S3 retry logic khi network issues

### Environment Variables Cần Thiết
```bash
# S3 Configuration
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION=us-east-1

# Integration-specific credentials
XERO_CLIENT_ID / MYOB_CLIENT_ID / QBO_CLIENT_ID
XERO_CLIENT_SECRET / MYOB_CLIENT_SECRET / QBO_CLIENT_SECRET

# Database (cho CMS fallback)
DB_HOST
DB_PASSWORD
DB_USER
```

---

**Logic này cho phép áp dụng 30-minute token caching, S3 storage, distributed locking, và CMS fallback cho bất kỳ OAuth integration nào.**