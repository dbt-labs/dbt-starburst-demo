{{ config(materialized='view') }}

with source as (

  select * from {{ source('airbnb','reviews') }}

),

renamed as (

  select
    id as review_id,
    listing_id,
    reviewer_id,
    reviewer_name,
    comments,
    to_date(date) as reviewed_at
  from source

)

select * from renamed