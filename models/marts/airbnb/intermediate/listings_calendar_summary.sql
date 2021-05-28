{{ config(materialized='view') }}

with calendar as (

    select * from {{ ref('dim_calendar') }}

),

calendar_summary as (

    select
        listing_id,

        min(minimum_nights) as minimum_minimum_nights,
        max(minimum_nights) as maximum_minimum_nights,
        avg(minimum_nights) as average_minimum_nights,
        min(maximum_nights) as minimum_maximum_nights,
        max(maximum_nights) as maximum_maximum_nights,
        avg(maximum_nights) as average_maximum_nights,

        {% for avail_interval in [30, 60, 90, 365] -%}
        sum(
            case 
                when is_available and availability_date between current_date() and date_add(current_date(), {{ avail_interval - 1 }})
                then 1 else 0
            end
        ) as availability_next_{{ avail_interval }}_days
        {%- if not loop.last -%},{% endif %}
        {% endfor %}
    
    from calendar
    where availability_date >= current_date()
    group by 1

)

select * from calendar_summary