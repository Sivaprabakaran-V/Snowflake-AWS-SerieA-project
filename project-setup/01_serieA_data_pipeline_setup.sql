-- PORJECT SERIE A
-- CREATING WAREHOUSE
-- warehouse created with size 'xsmall' which suspends  after 120 seconds of inactive
CREATE OR REPLACE WAREHOUSE SERIE_A WITH
WAREHOUSE_SIZE =  'XSMALL'
AUTO_SUSPEND = 120 
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED  = TRUE;

USE WAREHOUSE SERIE_A; -- USING SERIE A WAREHOUSE

-- CREATING A DATABASE
CREATE OR REPLACE DATABASE;
-- CREATINF SCHEMA FOR MANANIG EXTERNAL TABLES, views and file format
CREATE OR REPLACE SCHEMA serieA.external_stages;
CREATE OR REPLACE SCHEMA serieA.file_format;
CREATE OR REPLACE SCHEMA seriea.views;
CREATE or REPLACE SCHEMA seriea.pipes;
CREATE OR REPLACE SCHEMA seriea.streams;

-- CREATING A FILE FORMAT
CREATE OR REPLACE FILE FORMAT SERIEA.FILE_FORMAT.FILES
TYPE = csv
field_delimiter = ','
skip_header = 1
empty_field_as_null = TRUE
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- creating storage integration from aws

CREATE OR  REPLACE STORAGE INTEGRATION AWS_S3_INT
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::303258618127:role/snowflake-project-access-role'
STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-project43/serieA-results/')
COMMENT = 'STORAGE HAS BEEN CREATED';

DESC INTEGRATION AWS_S3_INT;

--Create stage object with integration object & file format object
CREATE OR REPLACE STAGE SERIEA.EXTERNAL_STAGES.CSV_FOLDER
URL = 's3://snowflake-project43/serieA-results/'
STORAGE_INTEGRATION = AWS_S3_INT
FILE_FORMAT = SERIEA.FILE_FORMAT.FILES;

LIST @SERIEA.EXTERNAL_STAGES.CSV_FOLDER;

-- CREATING A TABLE
CREATE OR REPLACE TABLE SERIEA.PUBLIC.serieA_matches
(
    id INT,
    match_date DATE,
    match_time STRING,
    competition STRING,
    round STRING,
    match_day STRING,
    venue STRING,
    result STRING,
    goals_for INT,
    goals_against INT,
    opponent STRING,
    expected_goals FLOAT,
    expected_goals_against FLOAT,
    possession FLOAT,
    attendance FLOAT,
    captain STRING,
    formation STRING,
    opponent_formation STRING,
    referee STRING,
    match_report STRING,
    notes STRING,
    shots FLOAT,
    shots_on_target FLOAT,
    avg_shot_distance FLOAT,
    free_kicks FLOAT,
    penalties_scored INT,
    penalties_attempted INT,
    season INT,
    team STRING
);

SELECT * FROM SERIEA.PUBLIC.SERIEA_MATCHES;


SELECT * FROM SERIEA.VIEWS.total_results;


--COPYING DATA FROM THE STAGE TO TABLE
COPY INTO SERIEA.PUBLIC.serieA_matches FROM @SERIEA.EXTERNAL_STAGES.CSV_FOLDER;

SELECT * FROM SERIEA.PUBLIC.serieA_matches;

-- creating a snowpipe for real time data intergation

CREATE OR REPLACE PIPE SERIEA.PIPES.SERIEA_PIPE
AUTO_INGEST = TRUE
AS 
COPY INTO SERIEA.PUBLIC.SERIEA_MATCHES
FROM @SERIEA.EXTERNAL_STAGES.CSV_FOLDER;

SHOW PIPES;

-- creating a stream to track the new record uploaded in the table
CREATE OR REPLACE STREAM SERIEA.STREAMS.match_stream 
ON TABLE SERIEA.PUBLIC.SERIEA_MATCHES
APPEND_ONLY = TRUE;

SHOW STREAMS;

-- creating a materialized view 

CREATE OR REPLACE MATERIALIZED VIEW SERIEA.VIEWS.total_results AS
SELECT * FROM SERIEA.PUBLIC.SERIEA_MATCHES; -- created materialized view to elimanate the time in executing the query



--  exploring the table

SELECT DISTINCT(TEAM) FROM SERIEA.PUBLIC.SERIEA_MATCHES;  -- there are 28 team participate in Serie A from season 2021 to 2025

SELECT SEASON,COUNT(DISTINCT(TEAM))FROM SERIEA.PUBLIC.SERIEA_MATCHES
GROUP BY SEASON; -- for each season there are 20 team participated