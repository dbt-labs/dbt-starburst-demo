{{ config(materialized='table') }}

with source as (

    select * from {{ ref('stg_airbnb_neighborhoods') }}

)

select * from source