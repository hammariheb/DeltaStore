select
    order_id,
    sum(amount) as total_amount
from {{ ref('stg_old_store_payments') }}
group by order_id
having sum(amount) < 0
