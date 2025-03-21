with customers as (
    select 
        *
    from {{ ref('int_customer_id_mapping') }}
)

select 
        c.unified_customer_id,
        c.customer_id,
        c.first_name,
        c.last_name,
        c.phone_number,
        c.email,
        c.address,
        c.city,
        ci.country_name,
        c.source_store, 
        c.created_at,
        c.updated_at    
from customers c
left join {{ ref('stg_cities_filtered') }} ci 
        ON LTRIM(RTRIM(c.city)) = LTRIM(RTRIM(ci.state_code))
        OR LTRIM(RTRIM(c.city)) = LTRIM(RTRIM(ci.state_name))