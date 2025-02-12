# Module 3 Homework 

## Question 1

What is count of records for the 2024 Yellow Taxi Data?

```sql
SELECT COUNT(*) FROM `zoomcamp-hw3-450705.nytaxi.yellow_tripdata_2024-01-06`;
```
- 20,332,093

## Question 2
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

```sql
SELECT COUNT(DISTINCT PULocationID) FROM `zoomcamp-hw3-450705.nytaxi.external_yellow_tripdata`;

SELECT COUNT(DISTINCT PULocationID) FROM `zoomcamp-hw3-450705.nytaxi.yellow_tripdata_2024-01-06`;
```
- 262
- 0 MB for External Table and 155.12 MB for the Materialized Table

## Question 3
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?

```sql
SELECT PULocationID FROM `zoomcamp-hw3-450705.nytaxi.yellow_tripdata_2024-01-06`;
SELECT PULocationID, DOLocationID FROM `zoomcamp-hw3-450705.nytaxi.yellow_tripdata_2024-01-06`;
```
First query estimated 155.12 MB to process.
Second query estimated 310.24 MB to process.

- BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.

## Question 4
How many records have a fare_amount of 0?

```sql
SELECT COUNT(*) FROM `zoomcamp-hw3-450705.nytaxi.yellow_tripdata_2024-01-06`
WHERE fare_amount = 0;
```
- 8,333

## Question 5
What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

```sql
CREATE OR REPLACE TABLE `zoomcamp-hw3-450705.nytaxi.yellow_trip_part_clust`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `zoomcamp-hw3-450705.nytaxi.external_yellow_tripdata`;
```
- Partition by tpep_dropoff_datetime and Cluster on VendorID

## Question 6
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?

Choose the answer which most closely matches.

```sql
SELECT DISTINCT(VendorID) FROM `zoomcamp-hw3-450705.nytaxi.yellow_tripdata_2024-01-06`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT(VendorID) FROM `zoomcamp-hw3-450705.nytaxi.yellow_trip_part_clust`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';
```
- 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table

## Question 7
Where is the data stored in the External Table you created?

- GCP Bucket

## Question 8
It is best practice in Big Query to always cluster your data:

- False

Up-front costs are unknown for queries involving clustering and would not be possible if queries are maintained to a budget.

## Question 9 
Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

0 B, BigQuery will infer our query and attempt to break it down to smaller sub-queries. If we run the query and check Within the execution details, we can see that the query is broken down to call an internal operator `COUNT_STAR()`, which, according to Google documentation, counts the number of rows.