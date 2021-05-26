{{ config(materialized='view') }}

with renamed as (

select
  neighbourhood_group   as neighborhood_group,
  neighbourhood           as neighborhood_name
from {{ source('airbnb','neighbourhoods') }}

)

select * from renamed