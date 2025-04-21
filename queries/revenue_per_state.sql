-- TODO: This query will return a table with two columns; customer_state, and 
-- Revenue. The first one will have the letters that identify the top 10 states 
-- with most revenue and the second one the total revenue of each.
-- HINT: All orders should have a delivered status and the actual delivery date 
-- should be not null. 

SELECT 
    oc.customer_state,  -- Select the customer state from the 'olist_customers' table
    SUM(oop.payment_value) AS Revenue  -- Calculate the total revenue from payment values and alias it as 'Revenue'
FROM 
    olist_customers oc,  -- Use the 'olist_customers' table and alias it as 'oc'
    olist_orders oo,  -- Use the 'olist_orders' table and alias it as 'oo'
    olist_order_payments oop  -- Use the 'olist_order_payments' table and alias it as 'oop'
WHERE 
    oo.order_status = 'delivered'  -- Filter for orders that have been delivered
    AND oo.order_delivered_customer_date IS NOT NULL  -- Ensure that the delivery date is not null
    AND oc.customer_id = oo.customer_id  -- Join 'olist_customers' and 'olist_orders' on customer_id
    AND oo.order_id = oop.order_id  -- Join 'olist_orders' and 'olist_order_payments' on order_id
GROUP BY 
    oc.customer_state  -- Group results by customer state
ORDER BY 
    Revenue DESC  -- Order results by revenue in descending order
LIMIT 10;  -- Limit results to the top 10 states by revenue

