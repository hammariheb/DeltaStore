with payments as (
    select *
    from {{ ref('stg_old_store_payments') }}
)

select 
    payment_unique_id,
    order_id,
    payment_method,
    amount,
    transaction_status,
    source_store
from payments