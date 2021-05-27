{{ config(materialized='view') }}

with source as (

  select * from {{ source('airbnb','neighbourhoods') }}

),

renamed as (

  select
    {{ dbt_utils.surrogate_key(
        'neighbouhood'
    ) }} as neighborhood_id,
    neighbourhood_group as neighborhood_group,
    neighbourhood as neighborhood_name
  from source

)

select * from renamed