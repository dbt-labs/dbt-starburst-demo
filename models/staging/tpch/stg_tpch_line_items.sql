with source as (

    select * from {{ source('tpch', 'lineitem') }}

),

renamed as (

    select
    
        {{ dbt_utils.surrogate_key(
            ['orderkey', 
            'linenumber']) }}
                as order_item_key,
        orderkey as order_key,
        partkey as part_key,
        suppkey as supplier_key,
        linenumber as line_number,
        quantity as quantity,
        extendedprice as extended_price,
        discount as discount_percentage,
        tax as tax_rate,
        returnflag as return_flag,
        linestatus as status_code,
        shipdate as ship_date,
        commitdate as commit_date,
        receiptdate as receipt_date,
        shipinstruct as ship_instructions,
        shipmode as ship_mode,
        comment as comment

    from source

)

select * from renamed