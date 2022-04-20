{{ config(materialized = 'table', enabled = false) }}

{{ dbt_utils.date_spine(
    datepart="month",
    start_date="cast('1992-01-01' as date)",
    end_date="cast('1998-08-02' as date)"
   )
}}
