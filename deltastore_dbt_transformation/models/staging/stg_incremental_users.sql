{{ 
  config(
    materialized = 'incremental',
    unique_key = 'id'
  ) 
}}

with source as (
    select *
    from {{ source('new_store', 'users') }}
),

monthly_new_users as (
    select
        datetrunc(month, created_at) as month_subscription,
        count(*) as nb_customers
    from source

    {% if is_incremental() %}
    where month_subscription >= (
        select coalesce(max(month_subscription), '1900-01-01') 
        from {{ this }}
    )
    {% endif %}
    group by datetrunc(month, created_at)
) 

select *
from monthly_new_users
