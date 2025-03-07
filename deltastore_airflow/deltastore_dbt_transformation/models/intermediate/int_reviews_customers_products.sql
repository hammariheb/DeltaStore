with reviews as (
    select *
    from {{ ref('stg_old_store_reviews') }}
),
int_product_id_mapping as (
    select *
    from {{ ref('int_product_id_mapping') }}
),
int_customer_id_mapping as (
    select *
    from {{ ref('int_customer_id_mapping') }}
)
select 
        r.review_unique_id,
        p.unified_product_id,
        c.unified_customer_id,
        r.rating,
        r.review_text,
        r.review_date,
        r.source_store
from reviews r
left join int_product_id_mapping p on r.product_id= p.product_id
left join int_customer_id_mapping c on r.customer_id= c.customer_id 