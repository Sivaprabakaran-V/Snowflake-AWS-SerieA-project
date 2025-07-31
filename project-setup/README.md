**Project Components**
The SQL script performs the following actions:
1. Warehouse Creation
   Creates an `XSMALL` warehouse named `SERIE_A` with auto suspend/resume configurations.
2. Database & Schema Setup
   Initializes a database and creates dedicated schemas for:
   - External Stages
   - File Formats
   - Views
   - Pipes
   - Streams
3. File Format Definition
   Defines a CSV file format to handle the dataset structure.
4. AWS S3 Storage Integration
   Integrates Snowflake with AWS S3 using an IAM role for secure access.
5. Stage Creation 
   Creates a named external stage pointing to the S3 bucket containing the Serie A CSV files.
6. Table Creation 
   Creates a `serieA_matches` table to store match-level data.
7. Data Ingestion  
   Uses `COPY INTO` to bulk load data from the S3 stage into the Snowflake table.
8. Snowpipe Configuration
   Automates continuous data ingestion using Snowpipe with `AUTO_INGEST`.
9. Stream Setup  
   Creates a stream to track new data inserts into the main table.
10. Materialized View
    Creates a materialized view (`total_results`) to optimize querying and eliminate repeated computation time.


---


