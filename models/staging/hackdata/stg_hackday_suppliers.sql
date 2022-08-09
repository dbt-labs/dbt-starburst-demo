with source as (

    select * from {{ source('tpch', 'supplier') }}

),

renamed as (

    select
    
        suppkey as supplier_key,
        name as supplier_name,
        address as supplier_address,
        nationkey as nation_key,
        phone as phone_number,
        acctbal as account_balance,
        comment as comment

    from source

)

select * from renamed