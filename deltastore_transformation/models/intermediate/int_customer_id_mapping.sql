with products as (
    select 
        customer_id,
        source_store
    from {{ ref('stg_old_store_customers') }}
    union all 
    select
        customer_id,
        source_store
    from {{ ref('stg_new_store_users') }}

)

select 
    {{ dbt_utils.generate_surrogate_key(['source_store', 'customer_id']) }} as unified_customer_id,
    source_store,
    customer_id
from products