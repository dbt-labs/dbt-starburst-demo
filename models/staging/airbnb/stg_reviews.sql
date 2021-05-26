{{ config(materialized='view') }}

with renamed as (

select
  listing_id        as listing_id,
  id                as review_id,
  to_date(date)     as review_date,
  reviewer_id       as reviewer_id,
  reviewer_name     as reviewer_name,
  comments          as comments
from {{ source('airbnb','reviews') }}

)

select * from renamed