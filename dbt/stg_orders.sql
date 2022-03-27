with orders as (
    
    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    --from raw.jaffle_shop.orders -- to begin the course
    from {{ source('jaffle_shop','orders') }} -- used in the source chapter
)

select * from orders