with products as (
    select 
        customer_id,
        first_name,
        last_name,
        phone_number,
        email,
        address,
        city,
        source_store,
        created_at,
        updated_at
    from {{ ref('stg_old_store_customers') }}
    union all 
    select
        customer_id,
        first_name,
        last_name,
        phone_number,
        email,
        address,
        cast(city as varchar) as city,
        source_store, 
        created_at,
        updated_at
    from {{ ref('stg_new_store_users') }}

)

select 
    *,
    {{ dbt_utils.generate_surrogate_key(['source_store', 'customer_id']) }} as unified_customer_id
    
from products