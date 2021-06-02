with orders as (
    
    select * from {{ ref('stg_tpch_orders') }}

),

line_item as (

    select * from {{ ref('stg_tpch_line_items') }}

)
select 

    line_item.order_item_key,
    orders.order_key,
    orders.customer_key,
    line_item.part_key,
    line_item.supplier_key,
    orders.order_date,
    orders.status_code as order_status_code,
    
    
    line_item.return_flag,
    
    line_item.line_number,
    line_item.status_code as order_item_status_code,
    line_item.ship_date,
    line_item.commit_date,
    line_item.receipt_date,
    line_item.ship_mode,
    line_item.extended_price,
    line_item.quantity,
    
    -- extended_price is actually the line item total,
    -- so we back out the extended price per item
    (line_item.extended_price/nullif(line_item.quantity, 0)){{ money() }} as base_price,
    line_item.discount_percentage,
    --mgf: databricks doesn't support resuable column aliases, updated references below to duplicate logic where applicable, could potentially move to macro
    (((line_item.extended_price/nullif(line_item.quantity, 0)){{ money() }}) * (1 - line_item.discount_percentage)){{ money() }} as discounted_price,

    line_item.extended_price as gross_item_sales_amount,
    (line_item.extended_price * (1 - line_item.discount_percentage)){{ money() }} as discounted_item_sales_amount,
    -- We model discounts as negative amounts
    (-1 * line_item.extended_price * line_item.discount_percentage){{ money() }} as item_discount_amount,
    line_item.tax_rate,
    ((line_item.extended_price + ((-1 * line_item.extended_price * line_item.discount_percentage){{ money() }})) * line_item.tax_rate){{ money() }} as item_tax_amount,
    (
        line_item.extended_price + 
        ((-1 * line_item.extended_price * line_item.discount_percentage){{ money() }}) + 
        (((line_item.extended_price + ((-1 * line_item.extended_price * line_item.discount_percentage){{ money() }})) * line_item.tax_rate){{ money() }})
    ){{ money() }} as net_item_sales_amount

from
    orders
inner join line_item
        on orders.order_key = line_item.order_key
order by
    orders.order_date