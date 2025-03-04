with shipments as (
    select *
    from {{ ref('stg_old_store_shipments') }}
)
select *
from shipments