{{
  config(
    materialized = 'incremental',
    unique_key= 'month_subscription'
    )
}}

with source as (
    select *
    from {{ source('new_store', 'users') }}
),
monthly_new_users as (
    select
        DATEFROMPARTS(YEAR(created_at), MONTH(created_at), 1) as month_subscription,
        id
    from source
)

select
    month_subscription,
    count(*) as nb_monthly_customers
from monthly_new_users

{% if is_incremental() %}
where month_subscription >= (
    select coalesce(convert(date, max(month_subscription)), '1900-01-01') 
    from {{ this }}
)
{% endif %}

group by month_subscription

