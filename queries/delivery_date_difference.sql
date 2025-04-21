-- TODO: This query will return a table with two columns; State, and 
-- Delivery_Difference. The first one will have the letters that identify the 
-- states, and the second one the average difference between the estimate 
-- delivery date and the date when the items were actually delivered to the 
-- customer.
-- HINTS:
-- 1. You can use the julianday function to convert a date to a number.
-- 2. You can use the CAST function to convert a number to an integer.
-- 3. You can use the STRFTIME function to convert a order_delivered_customer_date to a string removing hours, minutes and seconds.
-- 4. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL

SELECT 
    customer_state AS State,  -- Select the customer state and alias it as 'State'
    ABS(ROUND(AVG(ROUND(JULIANDAY(order_delivered_customer_date)) - JULIANDAY(order_estimated_delivery_date)))) AS Delivery_Difference  -- Calculate the average delivery difference in days and alias it as 'Delivery_Difference'
FROM 
    olist_customers oc  -- From the 'olist_customers' table and alias it as 'oc'
INNER JOIN 
    olist_orders oo ON oc.customer_id = oo.customer_id  -- Join with 'olist_orders' table on customer_id to associate orders with customers
WHERE 
    order_status = 'delivered'  -- Filter for orders that have been delivered
    AND order_delivered_customer_date IS NOT NULL  -- Ensure that the delivery date is not null
    AND order_estimated_delivery_date IS NOT NULL  -- Ensure that the estimated delivery date is not null
GROUP BY 
    customer_state  -- Group results by customer state
ORDER BY
    Delivery_Difference ASC;  -- Order the results by delivery difference in ascending order
