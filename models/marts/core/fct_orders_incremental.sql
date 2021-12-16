{{
    config(
        materialized='incremental',
        unique_key='order_key',
        incremental_strategy='merge'
    )
}}

select * from {{ref('fct_orders')}}
{% if is_incremental() %}
where order_date >= '1998-07-01'
{% else %}
where order_date < '1998-07-01'
{% endif %}