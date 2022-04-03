# Data-Warehouse

## Introduction
**TMDB Analytics with dbt, Airflow and Snowflake**

In this project, I will be analyzing our top movies & credits, and number of movies by decade from TMDB dataset. I use dbt to transform data, store to Snowflake warehouse and orchestrate data with Airflow.

Here are the tools that I will be using:

* Python - Used to create DAGs
* dbt (Data Build Tool) - Data modeling tool to transform our data in staging to fact, dimension tables, and views
* Airflow - A platform to programmatically author, schedule, and monitor workflows
* Docker - Containerizing our applications i.e. Postgres, dbt, and Metabase
* Snowflake - Store transform data into warehouse for analysis

## Download TMDB dataset

I use TMDB dataset from Kaggle in this project

Link: https://www.kaggle.com/datasets/tmdb/tmdb-movie-metadata

## Formula for IMDB's weighted rating 

To score the movies, I'll be using IMDB's weighted rating (wr) which is given as:

<p align="center">
  <img height="100" src="dbt-airflow/formula/IMDB's weighted rating.png">

where,

* v is the number of votes for the movie
* m is the minimum votes required to be listed in the chart
* R is the average rating of the movie
* C is the mean vote across the whole report

## Setup virtualenv:
1. Install virtualenv with pip
```
pip install virtualenv
```

2. Run virtualenv
```
virtualenv venv
```

## Setup docker environment:
1. Go to dbt-airflow folder
```
cd dbt-airflow
```

2. Get UID and GID of Airflow
```
echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > .env
```

3. Create volumns folders as root 
```
sudo mkdir -p ./dags ./logs ./plugins
```

4. (Optional) If you meet permission error when running docker
```
sudo chmod 777 -R <directory_name>
```

## Setup database, warehouse and role in Snowflake

Login to Snowflake and run the following query

1. Create role and user
```
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
```

2. Create virtual warehouse
```
USE ROLE SYSADMIN;

--Create Warehouse for dbt work
CREATE OR REPLACE WAREHOUSE tmdb_wh
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 120
  AUTO_RESUME = true
  INITIALLY_SUSPENDED = TRUE;
```

3. Create database
```
CREATE OR REPLACE DATABASE tmdb;
```

4. Create schema
```
CREATE OR REPLACE SCHEMA tmdb_movies;
```

5. Grant privileges 
```
GRANT ALL ON WAREHOUSE tmdb_wh TO ROLE tmdb_role;
GRANT USAGE ON DATABASE tmdb TO ROLE tmdb_role;
grant all privileges on schema tmdb.tmdb_movies to role tmdb_role;
GRANT USAGE ON WAREHOUSE tmdb_wh TO ROLE tmdb_role;
```

## Run project

1. Go to profiles.yml and replace `account` with your Snowflake account name 

2. Run `docker-compose up` to run Airflow

3. Go to http://localhost:8080/ (The default username is `airflow` and password is `airflow`)

4. Create 2 variables key-value. Go to `admin > Variables` and click on the `+` icon:
```
dbt_user: username of Snowflake account
dbt_password: password of Snowflake account
```

5. Run `dbt_seed_data` and `dbt_models` DAGs 