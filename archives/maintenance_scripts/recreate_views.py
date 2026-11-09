from sqlalchemy import text
from sql_helper import eva_main_engine, ExecuteEvaSP, ReadMySQLTable, CMS_DB_NAME



error_list = []

def recreate_views_for_eva_xb():
    # NOTE: This is a GENUINE cross-database query that joins tables from different databases:
    # - firms_with_containers (in evadb_stage/vibedb_stage)
    # - client, client_service (in etaniv2/vibedb_cms)
    # Therefore, database prefix IS required here for the CMS tables
    list_of_firms_sql = f"""
        SELECT firm_id, CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(c.Details, '$.Legacy.id')),c.id) AS CHAR(10)) as clientId
        FROM firms_with_containers fwc
        JOIN {CMS_DB_NAME}.client c ON fwc.firm_id = c.AccountingFirm
        JOIN {CMS_DB_NAME}.client_service cs on cs.Client = c.id
        WHERE cs.Service = 1
        AND fwc.integration = 'XB'
        and c.status <> 2
        AND cs.status <> 2
        AND REPLACE(JSON_EXTRACT(cs.Details, '$.dbDestination'),'"','') = 'DW'
        GROUP BY firm_id, c.id
    """
    df_firms = ReadMySQLTable(list_of_firms_sql, "RECREATE-VIEWS", 0, 0, error_list)
    with open("./MYSQL_SP_Revisions/evadb/xeroblue/_xeroblue_accrualtransactions_.sql", "r") as file:
        accruals_contents = file.read()
    with open("./MYSQL_SP_Revisions/evadb/xeroblue/_xeroblue_cashtransactions_.sql", "r") as file:
        cash_contents = file.read()
    with open("./MYSQL_SP_Revisions/evadb/xeroblue/_xeroblue_eva_budgets_.sql", "r") as file:
        budgets_contents = file.read()        
        
    views = [
        ("accruals", accruals_contents),
        ("cash", cash_contents),
        ("budgets", budgets_contents)
    ]
    # print(accruals_contents)
    for row in df_firms.itertuples(index=False):
        print(f"Recreating EVA views for firm_id: {row.firm_id} clientId: {row.clientId}")

        with eva_main_engine.connect() as connection:
            connection.execution_options(autocommit=True)
            for _, view_sql in views:
                safe_sql = view_sql.replace("'", "''").replace("\\", "\\\\")
                # No database prefix needed - eva_main_engine is already connected to evadb/vibedb
                # and sp_recreate_eva_views is in that same database
                connection.execute(
                    text("CALL sp_recreate_eva_views(:_firm_id, :_service_id, :_view_sql)"),
                    {"_firm_id": row.firm_id, "_service_id": 1, "_view_sql": view_sql}
                )
        
        print(f"Successfully recreated EVA views for firm_id: {row.firm_id} clientId: {row.clientId}")




recreate_views_for_eva_xb()