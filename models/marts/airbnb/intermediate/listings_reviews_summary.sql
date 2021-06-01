{{ config(materialized='view') }}

with reviews as (

    select * from {{ ref('fct_reviews') }}

),

reviews_summary as (

    select
        listing_id,

        count(*) as reviews_cnt,
        sum(
            case 
                when reviewed_at between date_sub(current_date(), 90) and current_date() 
                then 1 else 0
            end
        ) as reviews_in_last_90_days_cnt,
        min(reviewed_at) as first_review_at,
        max(reviewed_at) as last_review_at
    from reviews
    group by 1

)

select * from reviews_summary