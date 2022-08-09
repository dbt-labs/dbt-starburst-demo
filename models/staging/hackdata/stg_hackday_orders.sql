with source as (

    select * from {{ source('tpch', 'orders') }}

),


renamed as (

    select
    
        orderkey as order_key,
        custkey as customer_key,
        orderstatus as status_code,
        totalprice as total_price,
        orderdate as order_date,
        orderpriority as priority_code,
        clerk as clerk_name,
        shippriority as ship_priority,
        comment as comment

    from source

)

select * from renamed