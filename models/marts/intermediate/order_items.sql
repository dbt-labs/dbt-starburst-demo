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

derived_prices as (

    select 
        *,
        -- extended_price is actually the line item total,
        -- so we back out the extended price per item
        (projected.extended_price/nullif(projected.quantity, 0)) as raw_base_price,
        projected.extended_price as gross_item_sales_amount,
        (projected.extended_price * (1 - projected.discount_percentage)) as raw_discounted_item_sales_amount,
        -- We model discounts as negative amounts
        (-1 * projected.extended_price * projected.discount_percentage) as raw_item_discount_amount
    from projected

),

converted as (
  
    select *,
    
        -- use consistent decimal precision
    
        {{ convert_money('raw_base_price') }} as base_price,
        {{ convert_money('raw_discounted_item_sales_amount') }} as discounted_item_sales_amount,
        {{ convert_money('raw_item_discount_amount') }} as item_discount_amount
      
    from derived_prices
  
),

discount_tax as (
    
    select
        *,
        (base_price * (1 - converted.discount_percentage)) as discounted_price,
        ((gross_item_sales_amount + item_discount_amount) * converted.tax_rate) as item_tax_amount
    from converted

),

net_sales as (
    select 

        *,
        (
            gross_item_sales_amount + 
            item_discount_amount + 
            item_tax_amount
        ) as net_item_sales_amount

    from discount_tax

),

final as (

    select
        net_sales.order_item_key,
        net_sales.order_key,
        net_sales.customer_key,
        net_sales.part_key,
        net_sales.supplier_key,
        net_sales.order_date,
        net_sales.order_status_code,
        
        net_sales.return_flag,
        
        net_sales.line_number,
        net_sales.order_item_status_code,
        net_sales.ship_date,
        net_sales.commit_date,
        net_sales.receipt_date,
        net_sales.ship_mode,
        net_sales.base_price,
        net_sales.extended_price,
        net_sales.discounted_price,
        net_sales.item_tax_amount,
        net_sales.gross_item_sales_amount,
        net_sales.discounted_item_sales_amount,
        net_sales.net_item_sales_amount,
        net_sales.item_discount_amount,
        net_sales.quantity,
        net_sales.discount_percentage,
        net_sales.tax_rate
    from net_sales

)

select * from final