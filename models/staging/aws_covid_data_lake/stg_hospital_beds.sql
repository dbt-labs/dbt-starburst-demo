with source as (

    select * from {{ source('covid', 'hospital_beds') }}

),

renamed as (

    select
    
        objectid,
        hospital_name,
        hospital_type,
        hq_address,
        hq_address1,
        hq_city,
        hq_state,
        hq_zip_code,
        county_name,
        state_name,
        state_fips,
        cnty_fips,
        fips,
        num_licensed_beds,
        num_staffed_beds,
        num_icu_beds,
        adult_icu_beds,
        pedi_icu_beds,
        bed_utilization,
        avg_ventilator_usage,
        potential_increase_in_bed_capac,
        latitude,
        longitude

    from source

)

select * from renamed
