#!/usr/bin/env python3
"""
Generate CloseOut Stored Procedures for All Dynamic Integrations

This script generates CloseOut stored procedures in vibedb_cms for each integration.
These procedures are called at the end of each integration run to perform cleanup tasks.

Usage:
    python dynamic_integrations/generate_closeout_procedures.py

    # Or for a specific integration:
    python dynamic_integrations/generate_closeout_procedures.py --integration payroll_au
"""

import argparse
import os
import sys
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))


def get_all_integrations():
    """Get list of all generated integrations"""
    integrations_path = Path(__file__).parent / "generated_integrations"

    if not integrations_path.exists():
        return []

    integrations = []
    for item in integrations_path.iterdir():
        if item.is_dir() and not item.name.startswith('_'):
            # Check if it has an integration file
            integration_file = item / f"{item.name}_integration.py"
            if integration_file.exists():
                integrations.append(item.name)

    return sorted(integrations)


def generate_closeout_procedure(integration_name: str) -> str:
    """Generate CloseOut stored procedure SQL for an integration"""

    procedure_name = f"Dynamic-ETL-{integration_name.upper()}-Integration-CloseOut"

    sql = f"""-- =============================================
-- CloseOut Procedure for {integration_name.upper()} Integration
-- Generated: Auto-generated
-- =============================================

USE vibedb_cms;

DELIMITER $$

DROP PROCEDURE IF EXISTS `{procedure_name}`$$

CREATE PROCEDURE `{procedure_name}`(
    IN p_ClientID VARCHAR(50),
    IN p_OrganisationID INT,
    IN p_EtaniClientID VARCHAR(100),
    IN p_TriggerType VARCHAR(20),
    IN p_JobRunID INT
)
BEGIN
    DECLARE v_ErrorMessage VARCHAR(4000);
    DECLARE v_IntegrationName VARCHAR(50) DEFAULT '{integration_name.upper()}';

    DECLARE exit handler for sqlexception
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_ErrorMessage = MESSAGE_TEXT;

        -- Log error (table may not exist yet, so wrap in BEGIN...END)
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                SET v_ErrorMessage = CONCAT('Error logging failed: ', v_ErrorMessage);

            INSERT INTO integration_closeout_errors (
                integration_name,
                organisation_id,
                error_message,
                created_at
            ) VALUES (
                v_IntegrationName,
                p_OrganisationID,
                v_ErrorMessage,
                UTC_TIMESTAMP()
            );
        END;

        ROLLBACK;
    END;

    START TRANSACTION;

    -- =============================================
    -- CLOSEOUT TASKS FOR {integration_name.upper()}
    -- =============================================

    -- 1. Archive completed task records older than 30 days
    DELETE FROM task
    WHERE clientService = p_OrganisationID
      AND type = 'refresh'
      AND status = 'completed'
      AND createdAt < DATE_SUB(UTC_TIMESTAMP(), INTERVAL 30 DAY)
    LIMIT 100;

    -- 2. Update integration statistics in client_service
    UPDATE client_service
    SET
        LastRefreshDate = UTC_TIMESTAMP()
    WHERE Id = p_OrganisationID;

    -- 3. Clean up old temporary data (if applicable)
    -- Integration-specific cleanup can be added here

    -- 4. Update reconciliation summary table (if exists)
    -- Integration-specific reconciliation cleanup can be added here

    COMMIT;

    -- Log successful closeout
    SELECT CONCAT('[OK] CloseOut completed for ', v_IntegrationName, ' - OrgID: ', p_OrganisationID) AS CloseOutResult;

END$$

DELIMITER ;

-- =============================================
-- Grant Permissions
-- =============================================
-- GRANT EXECUTE ON PROCEDURE vibedb_cms.`{procedure_name}` TO 'etl_user'@'%';

-- =============================================
-- Usage Example:
-- =============================================
-- CALL `{procedure_name}`(
--     '6956',                              -- ClientID
--     1755241633,                          -- OrganisationID
--     'REDACTED',      -- EtaniClientID
--     'MANUAL',                            -- TriggerType
--     0                                    -- JobRunID
-- );
"""

    return sql


def main():
    parser = argparse.ArgumentParser(
        description='Generate CloseOut stored procedures for dynamic integrations'
    )
    parser.add_argument(
        '--integration',
        help='Generate for specific integration only (e.g., payroll_au)'
    )
    parser.add_argument(
        '--output-dir',
        default='dynamic_integrations/generated_integrations',
        help='Output directory for SQL files'
    )

    args = parser.parse_args()

    # Get integrations to process
    if args.integration:
        integrations = [args.integration.lower()]
    else:
        integrations = get_all_integrations()

    if not integrations:
        print("[ERROR] No integrations found")
        return 1

    print(f"[INFO] Generating CloseOut procedures for {len(integrations)} integration(s)...")
    print("")

    output_base = Path(args.output_dir)
    generated_count = 0

    for integration_name in integrations:
        try:
            # Generate SQL
            sql_content = generate_closeout_procedure(integration_name)

            # Determine output path
            integration_dir = output_base / integration_name / "sql"
            integration_dir.mkdir(parents=True, exist_ok=True)

            output_file = integration_dir / "closeout_procedure.sql"

            # Write SQL file
            output_file.write_text(sql_content, encoding='utf-8')

            print(f"[OK] Generated: {output_file}")
            print(f"     Procedure: Dynamic-ETL-{integration_name.upper()}-Integration-CloseOut")
            generated_count += 1

        except Exception as e:
            print(f"[ERROR] Failed to generate for {integration_name}: {e}")

    print("")
    print(f"[OK] Generated {generated_count} CloseOut procedure(s)")
    print("")
    print("Next steps:")
    print("1. Review generated SQL files")
    print("2. Execute SQL files in vibedb_cms database:")
    print("   mysql -h <host> -u <user> -p vibedb_cms < <sql_file>")
    print("")

    return 0


if __name__ == '__main__':
    sys.exit(main())
