with source as (

    select * from {{ source('aws', 'snow_owid_vaccinations') }}

),

renamed as (

    select
    
        date,
        country_region,
        iso3166_1,
        total_vaccinations,
        people_vaccinated,
        people_fully_vaccinated,
        daily_vaccinations_raw,
        daily_vaccinations,
        total_vaccinations_per_hundred,
        people_vaccinated_per_hundred,
        daily_vaccinations_per_million,
        vaccines,
        last_observation_date,
        source_name,
        source_website,
        from_iso8601_timestamp(last_update_date) as last_update_date,
        last_reported_flag

    from source

)

select * from renamed
