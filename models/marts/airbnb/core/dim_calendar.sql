{{ config(materialized='table') }}

with source as (

    select * from {{ ref('stg_airbnb_calendar') }}

)

select * from source