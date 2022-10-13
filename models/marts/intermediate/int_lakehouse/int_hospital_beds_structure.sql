
with hospital_beds as (
    select * from {{ ref('stg_hospital_beds') }}

),


final as (

SELECT
   hospital_name,
   county_name,
   state_name,
   fips,
   num_licensed_beds,
   num_staffed_beds,
   num_icu_beds,
   potential_increase_in_bed_capac
FROM
    hospital_beds

)

select * from final