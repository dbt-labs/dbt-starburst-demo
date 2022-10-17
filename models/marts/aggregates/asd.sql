
with cases as (
    select * from {{ ref('int_aws_cases') }}
),

with population as (
    select * from {{ ref('int_snow_population') }}
),

with location as (
    select * from {{ ref('int_tpch_location') }}
),

final as (
    
    select
        cases.nation_key,
        location.nation_key,
        cases.confirmed,
        location.region,
        population.total_population,
        population.vaccinated_population,
        first_value(cases.last_update) OVER (
            PARTITION BY cases.fips ORDER BY cases.last_update DESC) AS most_recent,
        cases.last_update
        )
    from
        cases
    inner join location
            on cases.country = location.nation
    inner join population
            on location.nation = population.country_region
)
select
    *
from
    final