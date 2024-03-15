with source as (

    select * from {{ source('aws', 'databank_demographics') }}

),

renamed as (

    select
    
        iso3166_1,
        iso3166_2,
        fips,
        latitude,
        longitude,
        state,
        county,
        total_population,
        total_male_population,
        total_female_population,
        country_region

    from source

)

select * from renamed
