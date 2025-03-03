with source as (
    select * 
    from {{ source('old_store', 'shipments') }}
),

new_store_shipments as (
    select
        shipment_id,
        order_id,
        shipment_date,
        delivery_date,
        datediff(day,shipment_date, delivery_date) as days_between_shipement_delivery,
        carrier,
        tracking_number,
        shipment_status
    from source
)
select * from new_store_shipments