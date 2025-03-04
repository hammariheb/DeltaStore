{{ 
  config(
    materialized = 'table'
  )
}}

with duplicates as (
    {{ check_duplicates('old_store', 'stg_old_store_reviews', 'customer_id') }}
)

select * from duplicates;
