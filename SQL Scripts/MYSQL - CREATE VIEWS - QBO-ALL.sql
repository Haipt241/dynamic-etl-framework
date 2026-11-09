
USE evadb;

DROP VIEW IF EXISTS bigoleshoecompany_client{clientID}_qbo_companyinfo;

CREATE VIEW bigoleshoecompany_client{clientID}_qbo_companyinfo AS
SELECT * FROM evadb_stage.c{clientID}_qbo_companyinfo;

DROP VIEW IF EXISTS bigoleshoecompany_client{clientID}_qbo_account;

CREATE VIEW bigoleshoecompany_client{clientID}_qbo_account AS
SELECT * FROM evadb_stage.c{clientID}_qbo_account;

DROP VIEW IF EXISTS bigoleshoecompany_client{clientID}_qbo_journalentry;

CREATE VIEW bigoleshoecompany_client{clientID}_qbo_journalentry AS
SELECT * FROM evadb_stage.c{clientID}_qbo_journalentry;

DROP VIEW IF EXISTS bigoleshoecompany_client{clientID}_qbo_bill;

CREATE VIEW bigoleshoecompany_client{clientID}_qbo_bill AS
SELECT * FROM evadb_stage.c{clientID}_qbo_bill;

DROP VIEW IF EXISTS bigoleshoecompany_client{clientID}_qbo_accountlistdetail;

CREATE VIEW bigoleshoecompany_client{clientID}_qbo_accountlistdetail AS
SELECT * FROM evadb_stage.c{clientID}_qbo_accountlistdetail;

DROP VIEW IF EXISTS bigoleshoecompany_client{clientID}_qbo_apagingdetail;

CREATE VIEW bigoleshoecompany_client{clientID}_qbo_apagingdetail AS
SELECT * FROM evadb_stage.c{clientID}_qbo_apagingdetail;

DROP VIEW IF EXISTS bigoleshoecompany_client{clientID}_qbo_apagingsummary;

CREATE VIEW bigoleshoecompany_client{clientID}_qbo_apagingsummary AS
SELECT * FROM evadb_stage.c{clientID}_qbo_apagingsummary;

DROP VIEW IF EXISTS bigoleshoecompany_client{clientID}_qbo_attachable;

CREATE VIEW bigoleshoecompany_client{clientID}_qbo_attachable AS
SELECT * FROM evadb_stage.c{clientID}_qbo_attachable;

DROP VIEW IF EXISTS bigoleshoecompany_client{clientID}_qbo_balancesheet;

CREATE VIEW bigoleshoecompany_client{clientID}_qbo_balancesheet AS
SELECT * FROM evadb_stage.c{clientID}_qbo_balancesheet;
