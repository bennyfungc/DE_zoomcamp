# Module 1 - Docker & SQL

## Question 1 - Understanding docker first run

Run docker:
```bash
docker run -it --entrypoint=bash python:3.12.8

pip --version
```

Results:
```
pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)
```

## Question 2 - Understanding Docker networking and docker-compose

`hostname` is `db` and the port is `5432`
- `db:5432` 

## Question 3 - Trip Segmentation Count

1. Up to 1 mile
```sql
SELECT COUNT(trip_distance)
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance <= 1;
```

2. Between 1 and 3 miles
```sql
SELECT COUNT(trip_distance)
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 1
  AND trip_distance <= 3;
```

3. Between 3 and 7 miles
```sql
SELECT COUNT(trip_distance)
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 3
  AND trip_distance <= 7;
```

4. Between 7 and 10 miles
```sql
SELECT COUNT(trip_distance)
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 7
  AND trip_distance <= 10;
```

5. Over 10 miles
```sql
SELECT COUNT(trip_distance)
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 10;
```

- 104,802; 198,924; 109,603; 27,678; 35,189

## Question 4 -  Longest trip for each day

Query:
```sql
SELECT DATE(lpep_pickup_datetime) AS pickup_date, 
       MAX(trip_distance) AS max_tripdistance
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01' AND 
      lpep_pickup_datetime < '2019-11-01'
GROUP BY DATE(lpep_pickup_datetime)
ORDER BY max_tripdistance DESC LIMIT 1;
```

Result:
```
+-------------+------------------+
| pickup_date | max_tripdistance |
|-------------+------------------|
| 2019-10-31  | 515.89           |
+-------------+------------------+
```

## Question 5 - Three biggest pickup zones

Query:
```sql
SELECT z."Zone", SUM(gt."total_amount") AS total_amount
FROM green_taxi_data AS gt
JOIN zones AS z ON gt."PULocationID" = z."LocationID"
WHERE DATE (gt."lpep_pickup_datetime") = '2019-10-18'
GROUP BY z."Zone"
HAVING SUM (gt."total_amount") > 13000
ORDER BY total_amount DESC LIMIT 3;
```

Result:
```
+---------------------+--------------------+
| Zone                | total_amount       |
|---------------------+--------------------|
| East Harlem North   | 18686.68000000007  |
| East Harlem South   | 16797.26000000007  |
| Morningside Heights | 13029.790000000028 |
+---------------------+--------------------+
```

## Question 6 - Largest tip

Query:
```sql
SELECT z."Zone", gt."tip_amount"
FROM green_taxi_data AS gt
JOIN zones z ON gt."DOLocationID" = z."LocationID"
WHERE DATE(gt."lpep_pickup_datetime") >= '2019-10-01'AND 
      DATE(gt."lpep_pickup_datetime") < '2019-11-01' AND
      gt."PULocationID" = 
        (SELECT "LocationID" FROM zones WHERE "Zone" = 'East Harlem North')
GROUP BY z."Zone", gt."tip_amount"
ORDER BY tip_amount DESC LIMIT 1;
```
Result:
```
+-------------+------------+
| Zone        | tip_amount |
|-------------+------------|
| JFK Airport | 87.3       |
+-------------+------------+
```


## Question 7 - Terraform Workflow

```bash
terraform init
terraform apply -auto-approve
terraform destroy
```

