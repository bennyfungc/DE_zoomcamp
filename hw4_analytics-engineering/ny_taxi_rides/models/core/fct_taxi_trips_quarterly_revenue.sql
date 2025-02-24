{{ config(materialized='table') }}

with trip_data as (
    select * from {{ ref('fact_trips') }}
)
select
    FORMAT_TIMESTAMP("%Y/Q%Q", pickup_datetime) as quarter, 
    service_type, 
    sum(total_amount) as quarterly_revenue
from trip_data
group by 1,2