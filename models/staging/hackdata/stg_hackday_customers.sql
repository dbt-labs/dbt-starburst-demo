with source as (

    select * from {{ source('tpch', 'customer') }}

),

renamed as (

    select
    
        custkey as customer_key,
        name as name,
        address as address, 
        nationkey as nation_key,
        phone as phone_number,
        acctbal as account_balance,
        mktsegment as market_segment,
        comment as comment

    from source

)

select * from renamed
