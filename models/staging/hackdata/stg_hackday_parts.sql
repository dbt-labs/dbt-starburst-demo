with source as (

    select * from {{ source('tpch', 'part') }}

),

renamed as (

    select
    
        partkey as part_key,
        name as name,
        mfgr as manufacturer,
        brand as brand,
        type as type,
        size as size,
        container as container,
        retailprice as retail_price,
        comment as comment

    from source

)

select * from renamed