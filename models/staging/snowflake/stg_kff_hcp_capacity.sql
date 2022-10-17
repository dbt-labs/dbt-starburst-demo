with source as (

    select * from {{ source('snowflake', 'kff_hcp_capacity') }}

),

renamed as (

    select
    
        country_region,
        province_state,
        total_hospital_beds,
        hospital_beds_per_1000_population,
        total_chcs,
        chc_service_delivery_sites

    from source

)

select * from renamed
