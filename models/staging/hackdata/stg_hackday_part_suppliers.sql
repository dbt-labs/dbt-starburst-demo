with source as (

    select * from {{ source('tpch', 'partsupp') }}

),

renamed as (

    select
    
        {{ dbt_utils.surrogate_key(
            ['partkey', 
            'suppkey']) }} 
                as part_supplier_key,
        partkey as part_key,
        suppkey as supplier_key,
        availqty as available_quantity,
        supplycost as cost,
        comment as comment

    from source

)

select * from renamed