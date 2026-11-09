/******************************************************************
APPLIED CHANGES:
DATE            CHANGES
2025-03-07      Latest version

*******************************************************************/

set sql_generate_invisible_primary_key = off;

CREATE TABLE foreignexchange_master(
 `BaseCurrency` VARCHAR(12) NULL,
 `Date` DATETIME NULL,
 `Currency` VARCHAR(12) NULL,
 `ExchangeRate` float NULL
);

CREATE TABLE python_package_log (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `JobId` BIGINT NULL,
    `JobRunId` BIGINT NULL,
    `DataSource` VARCHAR(255) NULL,
    `TaskName` VARCHAR(255) NULL,
    `StatusMessage` VARCHAR(255) NULL,
    `ErrorMessage` VARCHAR(255) NULL,
    `LogTimestamp` DATETIME DEFAULT CURRENT_TIMESTAMP
);