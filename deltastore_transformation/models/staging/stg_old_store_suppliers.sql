with source as (
    select *
    from {{ source('old_store', 'suppliers') }}
),

suppliers as (
    select 
        {{ dbt_utils.generate_surrogate_key(['supplier_id']) }} as supplier_unique_id,
        contact_name as supplier_full_name,
        LEFT(contact_name, CHARINDEX(' ', contact_name) - 1) AS supplier_first_name,
        RIGHT(contact_name, LEN(contact_name) - CHARINDEX(' ', contact_name)) AS supplier_last_name,
        phone_number,
        email,
        address
    from source
)
select *
from suppliers