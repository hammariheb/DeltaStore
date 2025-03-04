with payments as (
    select *
    from {{ ref('stg_old_store_payments') }}
)

select *
from payments