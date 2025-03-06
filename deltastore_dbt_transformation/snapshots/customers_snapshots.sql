{% snapshot customers_snapshot %}

{{
   config(
       target_schema='snapshots',
       unique_key='unified_customer_id',

       strategy='timestamp',
       updated_at= 'updated_at',
       hard_deletes='invalidate'
   )
}}

select *
from {{ ref('dim_customers') }}

{% endsnapshot %}

