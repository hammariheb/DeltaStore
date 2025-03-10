with duplicates as (
    {{ check_duplicates('stg_old_store_reviews', 'review_unique_id') }}
)

select * from duplicates; 