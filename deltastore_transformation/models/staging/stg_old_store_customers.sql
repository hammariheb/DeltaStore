with source as (
    select *
    from {{ source('old_store', 'customers') }}
),

customers as (
    select 
        customer_id,
        first_name,
        last_name,
        phone_number,
        email,
        address,
        RIGHT(address, CHARINDEX(',', REVERSE(address)+ ',') -1) AS city,
        created_at,
        'old store' as source_store,
        updated_at 
    from source
)
select *
from customers