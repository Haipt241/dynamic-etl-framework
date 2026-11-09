# AWS RDS Connection Pooling - Deployment Checklist

## Pre-Deployment

### ✅ 1. AWS IAM Setup

**Create IAM User for Azure Apps** (if not exists):

1. Go to AWS Console → IAM → Users → Create User
2. Name: `azure-app-secrets-reader` (or similar)
3. Attach policy with this JSON:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "arn:aws:secretsmanager:ap-northeast-3:*:secret:rds!cluster-44496612-3d03-451b-9749-88451f45fed7*"
    }
  ]
}
```

4. Create Access Key → Save `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

### ✅ 2. Verify Secret Format

1. Go to AWS Console → Secrets Manager → `rds!cluster-44496612-3d03-451b-9749-88451f45fed7`
2. Click "Retrieve secret value"
3. Verify it's in JSON format:
```json
{
  "username": "vibeadmin",
  "password": "your_actual_password"
}
```

If it's just a plain string password, that's okay too - the code handles both formats.

### ✅ 3. Update requirements.txt

Ensure `boto3>=1.26.0` is in your `requirements.txt` (already added).

## Azure App Service Configuration

### ✅ 4. Add Environment Variables

Go to your Azure App Service → **Configuration** → **Application settings** → **New application setting**

Add these three settings:

| Name | Value | Example |
|------|-------|---------|
| `AWS_ACCESS_KEY_ID` | Your IAM access key | `REDACTED` |
| `AWS_SECRET_ACCESS_KEY` | Your IAM secret key | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `AWS_DEFAULT_REGION` | `ap-northeast-3` | `ap-northeast-3` |

Click **Save** and **Restart** the app service.

## Code Deployment

### ✅ 5. Deploy New Files

Ensure these files are deployed to your Azure app:

```
etl_packages/
├── config.py                        (updated with AWS config)
├── aws_db_helper.py                 (new - main module)
├── test_aws_connection.py           (new - testing)
├── example_aws_usage.py             (new - examples)
├── AWS_CONNECTION_POOLING_README.md (new - full docs)
├── AWS_QUICK_REFERENCE.md           (new - quick ref)
└── DEPLOYMENT_CHECKLIST.md          (new - this file)
```

### ✅ 6. Update Your Application Code

**Minimal change to your existing code:**

Add this to your app initialization (e.g., `app.py`, `main.py`, or startup script):

```python
from aws_db_helper import initialize_aws_engine, close_aws_connections
import atexit

# Initialize AWS connection pool at startup
initialize_aws_engine(use_secrets_manager=True)

# Register cleanup on shutdown
atexit.register(close_aws_connections)
```

Then use in your ETL code:

```python
from aws_db_helper import read_aws_table, execute_aws_query, load_to_aws_table

# Replace Azure MySQL calls with AWS calls
df = read_aws_table("SELECT * FROM your_table")
```

## Testing

### ✅ 7. Local Testing (Optional)

If you want to test locally first:

```bash
# Set environment variables
export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret
export AWS_DEFAULT_REGION=ap-northeast-3

# Run test
cd etl_packages
python test_aws_connection.py --secrets-manager
```

### ✅ 8. Azure App Testing

After deployment:

1. **Check application logs** for initialization message:
   ```
   INFO - AWS RDS connection pool initialized successfully
   INFO - Retrieved credentials from AWS Secrets Manager for user: vibeadmin
   ```

2. **Test a simple query** in your app:
   ```python
   from aws_db_helper import read_aws_table
   df = read_aws_table("SELECT 1 as test")
   print(df)  # Should show: test=1
   ```

3. **Add a health check endpoint** (recommended):
   ```python
   from flask import jsonify
   from aws_db_helper import test_aws_connection, get_pool_status

   @app.route('/health/aws-db')
   def health_check():
       if test_aws_connection():
           status = get_pool_status()
           return jsonify({
               'status': 'healthy',
               'database': 'AWS RDS Aurora',
               'pool_size': status['pool_size'],
               'connections_in_use': status['checked_out_connections']
           })
       else:
           return jsonify({'status': 'unhealthy'}), 500
   ```

## Verification

### ✅ 9. Post-Deployment Checks

**Verify everything is working:**

- [ ] Application starts without errors
- [ ] Logs show: "AWS RDS connection pool initialized"
- [ ] Can read from database
- [ ] Can write to database
- [ ] Health check endpoint returns healthy
- [ ] No AWS credential errors in logs
- [ ] Connection pool is reusing connections (check logs for connection IDs)

**Monitor for 24 hours:**

- [ ] No connection timeout errors
- [ ] Pool size is adequate (not hitting max_overflow)
- [ ] Query performance is good (< 100ms for simple queries)

### ✅ 10. Performance Validation

Compare before/after:

**Before (Direct connections):**
```python
# Time to create connection + execute query: ~200-500ms
```

**After (Connection pooling):**
```python
# Time to execute query (reusing connection): ~10-50ms
```

You should see **5-10x faster** query execution!

## Rollback Plan

### If Issues Occur

**Option 1: Keep both systems running**

Your Azure MySQL connection still works. You can gradually migrate:

```python
# Old Azure code still works
from sql_helper import ReadMySQLTable
df_azure = ReadMySQLTable(query, endpoint, client_id, org_id, error_list)

# New AWS code
from aws_db_helper import read_aws_table
df_aws = read_aws_table(query)
```

**Option 2: Quick rollback**

1. Remove/comment out `initialize_aws_engine()` call
2. Keep using existing Azure MySQL code
3. Investigate and fix issues
4. Redeploy when ready

## Troubleshooting Common Issues

### Issue: "Unable to locate credentials"

**Fix:**
- Verify `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are in Azure App Service config
- Restart the app service after adding them

### Issue: "Access Denied" from Secrets Manager

**Fix:**
- Verify IAM policy includes `secretsmanager:GetSecretValue`
- Check the secret ARN matches: `rds!cluster-44496612-3d03-451b-9749-88451f45fed7`

### Issue: "Connection timeout"

**Fix:**
- Verify Aurora security group allows Azure App Service outbound IPs
- Check Aurora endpoint is publicly accessible (since you're connecting from Azure)
- Verify network connectivity: `telnet vibecfo-evadb.cxokc4emghb7.ap-northeast-3.rds.amazonaws.com 3306`

### Issue: "Too many connections"

**Fix:**
- Check current pool settings in `aws_db_helper.py`:
  - `pool_size=10` (standard connections)
  - `max_overflow=20` (extra connections if needed)
- Monitor: `get_pool_status()` to see actual usage
- Adjust if needed for your workload

## Monitoring (Recommended)

### Add these to your monitoring:

1. **Application Insights / Azure Monitor**:
   - Log all AWS connection errors
   - Track query execution times
   - Alert on connection pool exhaustion

2. **AWS CloudWatch** (if you have access):
   - Monitor Aurora connections count
   - Check for connection spikes

3. **Custom metrics**:
   ```python
   # Add to your monitoring
   status = get_pool_status()
   log_metric('aws.pool.size', status['pool_size'])
   log_metric('aws.pool.in_use', status['checked_out_connections'])
   log_metric('aws.pool.available', status['checked_in_connections'])
   ```

## Security Checklist

- [ ] AWS credentials stored in Azure App Service config (not in code)
- [ ] IAM user has minimal permissions (only read secret)
- [ ] Secret is in AWS Secrets Manager (not hardcoded)
- [ ] SSL enforced on Aurora connection (enabled by default)
- [ ] Network security group properly configured
- [ ] Credentials rotation plan in place

## Next Steps After Deployment

1. **Monitor for 1 week** - Watch logs and performance
2. **Migrate more services** - Apply to other ETL jobs
3. **Optimize pool settings** - Adjust based on actual usage
4. **Document your setup** - Add to your internal wiki
5. **Train team** - Share the Quick Reference guide

## Support Contacts

- **AWS Issues**: Your AWS account administrator
- **Azure Issues**: Your Azure subscription administrator
- **Code Issues**: Check `AWS_CONNECTION_POOLING_README.md`

---

## Quick Deployment Summary

1. ✅ Create IAM user with Secrets Manager permission
2. ✅ Add 3 environment variables to Azure App Service
3. ✅ Deploy new code files
4. ✅ Add `initialize_aws_engine()` to app startup
5. ✅ Test and verify
6. ✅ Monitor for 24 hours

**Estimated deployment time**: 30 minutes

**Ready to deploy? Start with Step 1!**
