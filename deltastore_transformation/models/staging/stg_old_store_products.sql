with source as (
    select *
    from {{ source('old_store', 'products') }}
),

products as (
    select 
        product_id,
        product_name,
        category,
        cast(round(price,2) as float) as price,
        supplier_id,
        updated_at
    from source
)
select *
from products