with source as (
    select *
    from {{ source('new_store', 'users') }}
),

new_store_users as (
    select
        id as customer_id,
        firstname as first_name,
        lastname as last_name,
        concat(firstname,' ', lastname) as full_name,
        email,
        city,
        phone as phone_number,
        case 
            when 
                street is not null and number is not null 
                then concat(number,' ', street) 
            else null 
            end as address,
        'new store' as source_store, 
        created_at,
        updated_at
    from source
)
select *
from new_store_users