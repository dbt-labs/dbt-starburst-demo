with enigma as (
    select * from {{ ref('stg_engima_jhu') }}

),

with cases as (
    SELECT
        fips,
        admin2 AS county,
        province_state,
        country_region,
        confirmed,
        first_value(last_update) OVER (
            PARTITION BY fips ORDER BY last_update DESC) AS most_recent,
        last_update
    FROM
        enigma
),

final as (

    SELECT
        fips,
        county,
        province_state,
        country_region,
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
        last_update;

)

select * from final