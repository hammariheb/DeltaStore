with source as (
select *
from {{ source('new_store', 'products') }}
),

new_sotre_products as (
    select
        id as product_id,
        title as product_name,
        description,
        category,
        price,
        rating_rate,
        updated_at
    from source
)
select *
from new_sotre_products