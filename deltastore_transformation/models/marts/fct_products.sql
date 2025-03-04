with int_product_id_mapping as (
    select *
    from {{ ref('int_product_id_mapping') }}
)
select
        unified_product_id,
        product_name,
        description,
        category,
        price,
        supplier_id,
        rating_rate,
        source_store,
        updated_at
from int_product_id_mapping