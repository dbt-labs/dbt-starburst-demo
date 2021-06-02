with orders as (
    select * from {{ ref('stg_tpch_orders') }}

),

line_item as (

    select * from {{ ref('stg_tpch_line_items') }}

),

projected as (

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
        line_item.discount_percentage,
        line_item.tax_rate

    from
        orders
    inner join line_item
            on orders.order_key = line_item.order_key
    order by
        orders.order_date

), 

derived_1 as (

    select 
        *,
        -- extended_price is actually the line item total,
        -- so we back out the extended price per item
        (projected.extended_price/nullif(projected.quantity, 0)){{ money() }} as base_price,
        projected.extended_price as gross_item_sales_amount,
        (projected.extended_price * (1 - projected.discount_percentage)){{ money() }} as discounted_item_sales_amount,
        -- We model discounts as negative amounts
        (-1 * projected.extended_price * projected.discount_percentage){{ money() }} as item_discount_amount
    from projected

), 

derived_2 as (
    
    select
        *,
        (base_price * (1 - derived_1.discount_percentage)){{ money() }} as discounted_price,
        ((gross_item_sales_amount + item_discount_amount) * derived_1.tax_rate){{ money() }} as item_tax_amount
    from derived_1

),

derived_3 as (
    select 
        *,
        (
            gross_item_sales_amount + 
            item_discount_amount + 
            item_tax_amount
        ){{ money() }} as net_item_sales_amount
    from derived_2
),

final as (

    select
        derived_3.order_item_key,
        derived_3.order_key,
        derived_3.customer_key,
        derived_3.part_key,
        derived_3.supplier_key,
        derived_3.order_date,
        derived_3.order_status_code,
        
        derived_3.return_flag,
        
        derived_3.line_number,
        derived_3.order_item_status_code,
        derived_3.ship_date,
        derived_3.commit_date,
        derived_3.receipt_date,
        derived_3.ship_mode,
        derived_3.base_price,
        derived_3.extended_price,
        derived_3.discounted_price,
        derived_3.item_tax_amount,
        derived_3.gross_item_sales_amount,
        derived_3.discounted_item_sales_amount,
        derived_3.net_item_sales_amount,
        derived_3.item_discount_amount,
        derived_3.quantity,
        derived_3.discount_percentage,
        derived_3.tax_rate
    from derived_3

)

select * from final