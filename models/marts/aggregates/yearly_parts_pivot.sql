{{ config(enabled = false) }}

/* Create a pivot table with hard-coded columns based on a query of the parts that are in the system */

{% set part_names = dbt_utils.get_column_values(table=ref('dim_parts'), column='name', max_records = 5) %}

with fct_order_items as (
    select * from {{ ref('fct_order_items') }}
),

dim_parts as (
    select * from {{ ref('dim_parts') }}
),

merged as (
    
    select
        year(fct_order_items.order_date) as order_year,
        dim_parts.name as part_name,
        fct_order_items.gross_item_sales_amount
    
    from fct_order_items
    join dim_parts
      on fct_order_items.part_key = dim_parts.part_key 

),

pivoted as (
  
    select
    
      order_year,      
    
      {% for name in part_names %}
    
        sum(case when part_name = '{{ name }}' then gross_item_sales_amount else null end) as {{ name | replace(" ", "_") }}_gross_sales {{ "," if not loop.last}}
        
      {% endfor %}
      
    from merged
    group by 1
  
  
)

select * from pivoted
