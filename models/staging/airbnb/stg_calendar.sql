{{ config(materialized='view') }}

with renamed as (

select
  listing_id            as listing_id,
  to_date(date)         as availability_date,
  boolean(available)    as is_available,
  price                 as is_available, -- price_dollars,
  adjusted_price        as adjusted_price_dollars,
  minimum_nights        as minimum_nights,
  maximum_nights        as maximum_nights
from {{ source('airbnb','calendar') }}

)

select * from renamed