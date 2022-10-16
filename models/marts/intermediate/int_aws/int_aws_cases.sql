with enigma as (
    select * from {{ ref('stg_enigma_jhu') }}

),


final as (

WITH
    cases AS (
        SELECT
            fips,
            county,
            province_state,
            replace(country_region, 'US', 'UNITED STATES') as country_region,
            confirmed,
            first_value(last_update) OVER (
              PARTITION BY fips ORDER BY last_update DESC) AS most_recent,
            last_update
        FROM
            enigma
    )
SELECT
    fips,
    county,
    province_state,
    UPPER(country_region) as country,
    confirmed,
    last_update
FROM
    cases
WHERE
    last_update = most_recent
GROUP BY
    fips,
    county,
    province_state,
    country_region,
    confirmed,
    last_update
)

select * from final