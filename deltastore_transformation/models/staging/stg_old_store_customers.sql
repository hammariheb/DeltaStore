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
        cast (created_at as timestamp) as created_at,
        updated_at
    from source
)
select *
from customers