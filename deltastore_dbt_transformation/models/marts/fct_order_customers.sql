-- models/fact/fct_orders.sql
with orders_with_unified_customer_id as (
    select 
        o.order_id,
        u.unified_customer_id,
        o.total_price,
        o.order_date
    from {{ ref('stg_old_store_orders') }} o
    left join {{ ref('int_customer_id_mapping') }} u
        on o.source_store = u.source_store
        and o.customer_id = u.customer_id
)

select * 
from orders_with_unified_customer_id
