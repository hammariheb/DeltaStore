with products as (
    select 
            product_id,
            product_name,
            description,
            category,
            price,
            supplier_id,
            rating_rate,
            source_store,
            updated_at
    from {{ ref('stg_old_store_products') }}
    union all 
    select
        product_id,
        product_name,
        description,
        category,
        price,
        supplier_id,
        rating_rate,
        source_store,
        updated_at
    from {{ ref('stg_new_store_products') }}

)

select 
    *,
    {{ dbt_utils.generate_surrogate_key(['source_store', 'product_id']) }} as unified_product_id
from products