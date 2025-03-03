with int_customer_id_mapping as (
    select *
    from {{ ref('int_customer_id_mapping') }}
)
select
        unified_customer_id,
        first_name,
        last_name,
        phone_number,
        email,
        address,
        city,
        source_store, 
        created_at,
        updated_at
from int_customer_id_mapping