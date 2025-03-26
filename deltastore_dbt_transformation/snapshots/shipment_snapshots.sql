{% snapshot shipment_snapshot %}

{{
   config(
       target_schema='snapshots',
       unique_key='shipment_id',

       strategy='check',
       check_cols=['shipment_status', 'delivery_date', 'shipment_date', 'carrier'],
       invalidate_hard_deletes= True
   )
}}

select *
from {{ ref('stg_old_store_shipments') }}

{% endsnapshot %}

