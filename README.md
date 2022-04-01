# Data-Warehouse
Create data warehouse with Airflow. dbt and Snowflake

echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > .env

USE ROLE SECURITYADMIN;

CREATE OR REPLACE ROLE tmdb_role COMMENT='tmdb_role';
GRANT ROLE tmdb_role TO ROLE SYSADMIN;

CREATE OR REPLACE USER tmdb_role 
	DEFAULT_ROLE=tmdb_role
	DEFAULT_WAREHOUSE=tmdb_wh
	COMMENT='tmdb User';
    
GRANT ROLE tmdb_role TO USER tmdb_role;

-- Grant privileges to role
USE ROLE ACCOUNTADMIN;

GRANT CREATE DATABASE ON ACCOUNT TO ROLE tmdb_role;

/*---------------------------------------------------------------------------
Next we will create a virtual warehouse that will be used
---------------------------------------------------------------------------*/
USE ROLE SYSADMIN;

--Create Warehouse for dbt work
CREATE OR REPLACE WAREHOUSE tmdb_wh
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 120
  AUTO_RESUME = true
  INITIALLY_SUSPENDED = TRUE;

GRANT ALL ON WAREHOUSE tmdb_wh TO ROLE tmdb_role;

CREATE OR REPLACE DATABASE tmdb;
CREATE OR REPLACE SCHEMA tmdb_movies;

GRANT USAGE ON DATABASE tmdb TO ROLE tmdb_role;
grant all privileges on schema tmdb.tmdb_movies to role tmdb_role;
GRANT USAGE ON WAREHOUSE tmdb_wh TO ROLE tmdb_role;