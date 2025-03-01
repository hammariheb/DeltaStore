-- models/fact/fct_orders.sql
with order_items_with_unified_product_id as (
    select 
        oi.order_item_unique_id,
        o.order_id,
        u.unified_product_id,
        oi.quantity,
        oi.price_at_purchase,
        oi.source_store
    from {{ ref('stg_old_store_order_items') }} oi
    left join {{ ref('stg_old_store_orders') }} o
        on oi.order_id= o.order_id
        and oi.source_store = o.source_store
    left join {{ ref('int_product_id_mapping') }} u
        on oi.source_store = u.source_store
        and oi.product_id = u.product_id
)

select * 
from order_items_with_unified_product_id
