-- TODO: This query will return a table with the top 10 revenue categories in 
-- English, the number of orders and their total revenue. The first column will 
-- be Category, that will contain the top 10 revenue categories; the second one 
-- will be Num_order, with the total amount of orders of each category; and the 
-- last one will be Revenue, with the total revenue of each catgory.
-- HINT: All orders should have a delivered status and the Category and actual 
-- delivery date should be not null.


SELECT 
    pcnt.product_category_name_english AS Category,  -- Select the English name of the product category and alias it as 'Category'
    COUNT(DISTINCT oo.order_id) AS Num_order,  -- Count the number of distinct order IDs and alias it as 'Num_order'
    SUM(oop.payment_value) AS Revenue  -- Calculate the total revenue from payment values and alias it as 'Revenue'
FROM 
    product_category_name_translation pcnt,  -- Use the 'product_category_name_translation' table and alias it as 'pcnt'
    olist_orders oo,  -- Use the 'olist_orders' table and alias it as 'oo'
    olist_order_payments oop,  -- Use the 'olist_order_payments' table and alias it as 'oop'
    olist_products op,  -- Use the 'olist_products' table and alias it as 'op'
    olist_order_items ooi  -- Use the 'olist_order_items' table and alias it as 'ooi'
WHERE 
    oo.order_status = 'delivered'  -- Filter for orders that have been delivered
    AND pcnt.product_category_name_english IS NOT NULL  -- Ensure the product category name is not null
    AND oo.order_delivered_customer_date IS NOT NULL  -- Ensure the delivery date is not null
    AND pcnt.product_category_name = op.product_category_name  -- Join 'product_category_name_translation' and 'olist_products' on product category name
    AND op.product_id = ooi.product_id  -- Join 'olist_products' and 'olist_order_items' on product ID
    AND ooi.order_id = oo.order_id  -- Join 'olist_order_items' and 'olist_orders' on order ID
    AND oo.order_id = oop.order_id  -- Join 'olist_orders' and 'olist_order_payments' on order ID
GROUP BY 
    pcnt.product_category_name_english  -- Group results by product category name in English
ORDER BY 
    Revenue DESC  -- Order results by revenue in descending order
LIMIT 10;  -- Limit results to the top 10 categories by revenue
