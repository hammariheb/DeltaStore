with source as (
    select *
    from {{ source('old_store', 'reviews') }}
),

reviews as (
    select 
        {{ dbt_utils.generate_surrogate_key(['review_id']) }} as review_unique_id,
        product_id,
        customer_id,
        rating,
        review_text,
        cast(review_date as date) as review_date,
        'old store' as source_store
    from source
)
select *
from reviews