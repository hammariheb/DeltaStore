with source as (
    select *
    from {{ source('old_store', 'order_items') }}
),

orders as (
    select 
        {{ dbt_utils.generate_surrogate_key(['order_item_id']) }} as order_item_unique_id,
        order_id,
        product_id,
        quantity,
        cast(round(price_at_purchase,2) as float) as price_at_purchase
    from source
)
select *
from orders