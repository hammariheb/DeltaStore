with source as (
    select *
    from {{ source('old_store', 'products') }}
),

products as (
    select 
         product_id,
         product_name,
            case 
            when product_name is not null 
            then 'This is a ' + product_name + ' in the category ' + category
            else 'No product information available'
        end as description,
        category,
        cast(round(price,2) as float) as price,
        supplier_id,
        null as rating_rate,
        'old store' as source_store,
        updated_at
    from source
)
select *
from products