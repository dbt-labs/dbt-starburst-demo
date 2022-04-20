{{ config(enabled = false) }}

with fct_orders as (
    select * from {{ ref('fct_orders') }}
),

dim_customers as (
    select * from {{ ref('dim_customers') }}
),

month_spine as (
    select * from {{ ref('all_months') }}
),

joined as (

    select
        month_spine.date_month,
        fct_orders.customer_key,
        dim_customers.name as customer_name,
        fct_orders.gross_item_sales_amount
    
    from month_spine
    join fct_orders
      on month_spine.date_month = date_trunc('month', fct_orders.order_date)
    join dim_customers
      on fct_orders.customer_key = dim_customers.customer_key

),

totaled as (
  
    select
    
        date_month,
        customer_key,
        customer_name,
        sum(gross_item_sales_amount) as gross_item_sales_amount
        
    from joined
    group by 1,2,3
  
),

lagged as (
  
    select
    
      date_month,
      customer_key,
      customer_name,
      gross_item_sales_amount,
      lag(gross_item_sales_amount) over (partition by customer_key order by date_month) as last_month_amount
      
    from totaled
  
  
)

select * from lagged
-- make sure it worked
-- where last_month_amount is not null
