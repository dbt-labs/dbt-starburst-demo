{{ config(tags = ['population']) }}

with demographics as (
    
    select * from {{ ref('stg_databank_demographics') }}

),

vaccines as (
    
    select * from {{ ref('stg_owid_vaccinations') }}

),

final as (
    
    select
        UPPER(demographics.country_region),
        demographics.total_population,
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
    *
from
    final
