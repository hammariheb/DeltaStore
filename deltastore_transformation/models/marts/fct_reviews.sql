with reviews as (
    select *
    from {{ ref('int_reviews_customers_products') }}
)
select *
from reviews