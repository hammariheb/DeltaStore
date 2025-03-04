with int_customer_id_mapping as (
    select *
    from {{ ref('int_customers_cities') }}
)
select
        unified_customer_id,
        first_name,
        last_name,
        phone_number,
        email,
        address,
        city,
        country_name,
        source_store, 
        created_at,
        updated_at
from int_customer_id_mapping 