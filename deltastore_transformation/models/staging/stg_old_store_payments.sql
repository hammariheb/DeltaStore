with source as (
    select *
    from {{ source('old_store', 'payment') }}
),

payments as (
    select 
        {{ dbt_utils.generate_surrogate_key(['payment_id']) }} as payment_unique_id,
        order_id,
        payment_method,
        cast(round(amount,2) as float) as amount,
        transaction_status
    from source
)
select *
from payments