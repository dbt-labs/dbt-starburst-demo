{{ config(materialized='view') }}

with source as (

  select * from {{ source('airbnb','listings') }}

),

renamed as (

    select
        id as listing_id,
        host_id,
        listing_url,
        name as listing_name,
        description as listing_description,
        property_type,
        room_type,
        accommodates as num_accommodates,
        bathrooms as num_bathrooms,
        bathrooms_text as num_bathrooms_text,
        beds as num_beds,
        amenities,
        price as price_in_dollars,
        minimum_nights,
        maximum_nights,
        picture_url,
        license as license_type,
        calculated_host_listings_count,
        calculated_host_listings_count_entire_homes,
        calculated_host_listings_count_private_rooms,
        calculated_host_listings_count_shared_rooms,

        -- Host details / dimensions
        host_url,
        host_location,
        host_about,
        host_response_time,
        host_response_rate,
        host_acceptance_rate,
        host_thumbnail_url,
        host_neighbourhood as host_neighborhood,
        -- host_listings_count,
        -- host_total_listings_count,
        host_verifications as host_verifications_cnt,

        -- Location details
        neighbourhood as neighborhood,
        neighbourhood_cleansed as neighborhood_cleansed,
        neighborhood_overview as neighborhood_overview,
        latitude,
        longitude,

        -- Review details
        review_scores_rating,
        review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value,
        reviews_per_month,

        boolean(instant_bookable) as is_instant_bookable,
        boolean(host_has_profile_pic) as has_host_profile_pic,
        boolean(host_identity_verified) as is_host_verified,
        boolean(host_is_superhost) as is_host_superhost,
        boolean(has_availability) as has_availability,
        to_date(last_scraped) as listing_last_scraped_at,
        to_date(calendar_last_scraped) as calendar_last_scraped_at,
        to_date(calendar_updated) as calendar_updated_at,
        to_date(host_since) as host_since
    from source

)

select * from renamed