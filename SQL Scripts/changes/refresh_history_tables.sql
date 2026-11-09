--
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8mb4';

--
-- Set default database
--
USE etaniv2;

--
-- Create table `historic_last_refresh_date`
--
CREATE TABLE historic_last_refresh_date (
  id int UNSIGNED NOT NULL AUTO_INCREMENT,
  task int UNSIGNED DEFAULT NULL,
  clientService int UNSIGNED DEFAULT NULL,
  business int UNSIGNED DEFAULT NULL,
  client int UNSIGNED DEFAULT NULL,
  service int UNSIGNED DEFAULT NULL,
  lastRefreshDateRecord longtext DEFAULT NULL,
  createdAt datetime DEFAULT CURRENT_TIMESTAMP,
  updatedAt datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 641631,
AVG_ROW_LENGTH = 18448,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_0900_ai_ci,
ROW_FORMAT = DYNAMIC;

--
-- Create index `taskID` on table `historic_last_refresh_date`
--
ALTER TABLE historic_last_refresh_date
ADD INDEX taskID (task);

--
-- Create foreign key
--
ALTER TABLE historic_last_refresh_date
ADD CONSTRAINT business_historic_last_refresh FOREIGN KEY (business)
REFERENCES accounting_firm (id);

--
-- Create foreign key
--
ALTER TABLE historic_last_refresh_date
ADD CONSTRAINT client_historic_last_refresh FOREIGN KEY (client)
REFERENCES client (id);

--
-- Create foreign key
--
ALTER TABLE historic_last_refresh_date
ADD CONSTRAINT client_service_historic_last_refresh FOREIGN KEY (clientService)
REFERENCES client_service (id);

--
-- Create foreign key
--
ALTER TABLE historic_last_refresh_date
ADD CONSTRAINT service_historic_last_refresh FOREIGN KEY (service)
REFERENCES service (id);

--
-- Create foreign key
--
ALTER TABLE historic_last_refresh_date
ADD CONSTRAINT task_historic_last_refresh FOREIGN KEY (task)
REFERENCES task (id);



--
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8mb4';

--
-- Set default database
--
USE etaniv2;

--
-- Create table `task`
--
CREATE TABLE task (
  id int UNSIGNED NOT NULL AUTO_INCREMENT,
  taskId varchar(255) DEFAULT NULL,
  type varchar(255) DEFAULT NULL,
  business int UNSIGNED DEFAULT NULL,
  client int UNSIGNED DEFAULT NULL,
  clientService int UNSIGNED DEFAULT NULL,
  details longtext DEFAULT NULL,
  status varchar(255) DEFAULT 'pending',
  progress varchar(255) DEFAULT '0',
  createdAt datetime DEFAULT CURRENT_TIMESTAMP,
  updatedAt datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 253798,
AVG_ROW_LENGTH = 757,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_0900_ai_ci,
ROW_FORMAT = DYNAMIC;

--
-- Create foreign key
--
ALTER TABLE task
ADD CONSTRAINT business_task FOREIGN KEY (business)
REFERENCES accounting_firm (id);

--
-- Create foreign key
--
ALTER TABLE task
ADD CONSTRAINT client_task FOREIGN KEY (client)
REFERENCES client (id);

--
-- Create foreign key
--
ALTER TABLE task
ADD CONSTRAINT service_task FOREIGN KEY (clientService)
REFERENCES client_service (id);


--
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8mb4';

--
-- Set default database
--
USE evadb_stage;

--
-- Create table `c1240_xeroblue_lastrefreshdate`
--
CREATE TABLE c1240_xeroblue_lastrefreshdate (
  Id int NOT NULL,
  TableName varchar(255) DEFAULT NULL,
  RefreshRowCount int DEFAULT NULL,
  TotalRowCount int DEFAULT NULL,
  StartDate datetime DEFAULT NULL,
  EndDate datetime DEFAULT NULL,
  LastRefreshUTCDate datetime DEFAULT NULL,
  LoadType varchar(255) DEFAULT NULL,
  RefreshStatus varchar(255) DEFAULT NULL,
  RefreshDetails text DEFAULT NULL,
  JobRunId bigint DEFAULT NULL,
  DatabaseDestination varchar(255) DEFAULT NULL,
  TriggerType varchar(255) DEFAULT NULL,
  ClientID varchar(255) DEFAULT NULL,
  OrganisationID int DEFAULT NULL,
  PRIMARY KEY (Id)
)
ENGINE = INNODB,
AVG_ROW_LENGTH = 248,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_0900_ai_ci,
ROW_FORMAT = DYNAMIC;

--
-- Create index `unique_table_client_org` on table `c1240_xeroblue_lastrefreshdate`
--
ALTER TABLE c1240_xeroblue_lastrefreshdate
ADD UNIQUE INDEX unique_table_client_org (TableName, ClientID, OrganisationID);