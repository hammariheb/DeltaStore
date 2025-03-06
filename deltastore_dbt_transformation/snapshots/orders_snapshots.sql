{% snapshot orders_snapshot %}

{{
   config(
       target_schema='snapshots',
       unique_key='order_id',

       strategy='timestamp',
       updated_at= 'updated_at',
       hard_deletes='invalidate'
   )
}}

select *
from {{ ref('stg_old_store_orders') }}

{% endsnapshot %}

