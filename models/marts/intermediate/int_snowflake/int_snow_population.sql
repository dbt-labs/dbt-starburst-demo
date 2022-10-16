{{ config(tags = ['population']) }}

with demographics as (
    
    select * from {{ ref('stg_databank_demographics') }}

),

vaccines as (
    
    select * from {{ ref('stg_owid_vaccinations') }}

),

final as (
    
    select
        demographics.country_region as country_region,
        demographics.total_population as total_population,
        max(vaccines.people_vaccinated) as vaccinated_population
    from
        demographics
    inner join vaccines
            on demographics.country_region = vaccines.country_region
    group by
        demographics.country_region,
        demographics.total_population
)
select
    UPPER(country_region) as country_region,
    total_population,
    vaccinated_population
from
    final
