with source as (
    select *
    from {{ source('old_store', 'orders') }}
),

orders as (
    select 
        order_id,
        cast(order_date as date) as order_date,
        customer_id,
        cast(round(total_price, 2) as float) as total_price,
        updated_at,
        'old store' as source_store
    from source
)
select *
from orders