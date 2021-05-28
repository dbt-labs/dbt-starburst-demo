{{ config(materialized='table') }}

with listings as (

    select * from {{ ref('stg_listings') }}

),

calendar_summary as (

    select * from {{ ref('listings_calendar_summary') }}

),

reviews_summary as (

    select * from {{ ref('listings_reviews_summary') }}

),

final as (

    select
        listings.listing_id,
        listings.host_id,
        listings.listing_url,
        listings.listing_name,
        listings.listing_description,
        listings.property_type,
        listings.room_type,
        listings.num_accommodates,
        listings.num_bathrooms,
        listings.num_bathrooms_text,
        listings.num_beds,
        listings.amenities,
        listings.price_in_dollars,
        listings.minimum_nights,
        listings.maximum_nights,
        listings.picture_url,
        listings.license_type,
        listings.calculated_host_listings_count,
        listings.calculated_host_listings_count_entire_homes,
        listings.calculated_host_listings_count_private_rooms,
        listings.calculated_host_listings_count_shared_rooms,
        listings.host_url,
        listings.host_location,
        listings.host_about,
        listings.host_response_time,
        listings.host_response_rate,
        listings.host_acceptance_rate,
        listings.host_thumbnail_url,
        listings.host_neighborhood,
        listings.host_verifications_cnt,
        listings.neighborhood,
        listings.neighborhood_cleansed,
        listings.neighborhood_overview,
        listings.latitude,
        listings.longitude,
        listings.review_scores_rating,
        listings.review_scores_accuracy,
        listings.review_scores_cleanliness,
        listings.review_scores_checkin,
        listings.review_scores_communication,
        listings.review_scores_location,
        listings.review_scores_value,
        listings.reviews_per_month,
        listings.is_instant_bookable,
        listings.has_host_profile_pic,
        listings.is_host_verified,
        listings.is_host_superhost,
        listings.has_availability,
        listings.listing_last_scraped_at,
        listings.calendar_last_scraped_at,
        listings.calendar_updated_at,
        listings.host_since,
        
        calendar_summary.minimum_minimum_nights,
        calendar_summary.maximum_minimum_nights,
        calendar_summary.average_minimum_nights,
        calendar_summary.minimum_maximum_nights,
        calendar_summary.maximum_maximum_nights,
        calendar_summary.average_maximum_nights,
        calendar_summary.availability_next_30_days,
        calendar_summary.availability_next_60_days,
        calendar_summary.availability_next_90_days,
        calendar_summary.availability_next_365_days,

        reviews_summary.reviews_cnt,
        reviews_summary.reviews_in_last_90_days_cnt,
        reviews_summary.first_review_at,
        reviews_summary.last_review_at
    from 
        listings 
    left join
        calendar_summary 
            on listings.listing_id = calendar_summary.listing_id
    left join
        reviews_summary
            on listings.listing_id = reviews_summary.listing_id

)

select * from final