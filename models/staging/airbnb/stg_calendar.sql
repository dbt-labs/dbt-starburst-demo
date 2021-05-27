{{ config(materialized='view') }}

with source as (

  select * from {{ source('airbnb','calendar') }}

),

renamed as (

  select
    {{ dbt_utils.surrogate_key(
        'listing_id',
        'availability_date'
    ) }} as calendar_id,
    listing_id,
    price as price_in_dollars,
    adjusted_price as adjusted_price_in_dollars,
    minimum_nights,
    maximum_nights,
    boolean(available) as is_available,
    to_date(date) as availability_date
  from source

)

select * from renamed