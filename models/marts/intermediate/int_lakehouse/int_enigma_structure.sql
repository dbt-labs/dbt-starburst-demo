
with enigma as (
    select * from {{ ref('stg_enigma_jhu') }}

),


final as (

SELECT
    fips,
    county,
    province_state,
    country_region,
    confirmed
FROM
    enigma
WHERE
    country_region = 'US'
    and province_state not like ''
    and last_update = '2020-05-30T02:32:48'

)

select * from final