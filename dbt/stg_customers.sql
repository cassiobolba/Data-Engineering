with customers as (
    
    select 
        id as customer_id,
        first_name,
        last_name

    --from raw.jaffle_shop.customers -- to begin the course
    from {{ source('jaffle_shop','customers') }} -- used in the source chapter
)

select * from customers
