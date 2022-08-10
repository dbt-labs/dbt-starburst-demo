with source as (

    select * from {{ source('hackday', 'chicago_taxi_trips_parquet') }}

),

renamed as (

    select
        unique_key             ,
        taxi_id                ,
        trip_start_timestamp   ,
        trip_end_timestamp     ,
        trip_seconds           ,
        trip_miles             ,
        pickup_census_tract    ,
        dropoff_census_tract   ,
        pickup_community_area  ,
        dropoff_community_area ,
        fare                   ,
        tips                   ,
        tolls                  ,
        extras                 ,
        trip_total             ,
        payment_type           ,
        company                ,
        pickup_latitude        ,
        pickup_longitude       ,
        pickup_location        ,
        dropoff_latitude       ,
        dropoff_longitude      ,
        dropoff_location       
    from source

)

select * from renamed
