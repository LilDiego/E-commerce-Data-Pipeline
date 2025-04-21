-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.

WITH delivery_data AS (
    SELECT 
        order_id,  -- Select the order ID for each order
        strftime('%Y', order_purchase_timestamp) AS year,  -- Extract the year from the order purchase timestamp
        strftime('%m', order_purchase_timestamp) AS month_no,  -- Extract the month number from the order purchase timestamp
        strftime('%m', order_purchase_timestamp) AS month,  -- Extract the month number again (this could be renamed for clarity)
        JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp) AS real_delivery_time,  -- Calculate the actual delivery time in days
        JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp) AS estimated_delivery_time  -- Calculate the estimated delivery time in days
    FROM 
        olist_orders  -- From the 'olist_orders' table
    WHERE 
        order_status = 'delivered'  -- Filter for orders that have been delivered
        AND order_delivered_customer_date IS NOT NULL  -- Ensure that the delivery date is not null
)
SELECT
    month_no,  -- Select the month number for grouping
    CASE month_no  -- Convert month number to month name
        WHEN '01' THEN 'Jan'
        WHEN '02' THEN 'Feb'
        WHEN '03' THEN 'Mar'
        WHEN '04' THEN 'Apr'
        WHEN '05' THEN 'May'
        WHEN '06' THEN 'Jun'
        WHEN '07' THEN 'Jul'
        WHEN '08' THEN 'Aug'
        WHEN '09' THEN 'Sep'
        WHEN '10' THEN 'Oct'
        WHEN '11' THEN 'Nov'
        WHEN '12' THEN 'Dec'
    END AS month,  -- Alias the month name as 'month'
    AVG(CASE WHEN year = '2016' THEN real_delivery_time END) AS Year2016_real_time,  -- Calculate average real delivery time for 2016
    AVG(CASE WHEN year = '2017' THEN real_delivery_time END) AS Year2017_real_time,  -- Calculate average real delivery time for 2017
    AVG(CASE WHEN year = '2018' THEN real_delivery_time END) AS Year2018_real_time,  -- Calculate average real delivery time for 2018
    AVG(CASE WHEN year = '2016' THEN estimated_delivery_time END) AS Year2016_estimated_time,  -- Calculate average estimated delivery time for 2016
    AVG(CASE WHEN year = '2017' THEN estimated_delivery_time END) AS Year2017_estimated_time,  -- Calculate average estimated delivery time for 2017
    AVG(CASE WHEN year = '2018' THEN estimated_delivery_time END) AS Year2018_estimated_time  -- Calculate average estimated delivery time for 2018
FROM 
    delivery_data  -- Use the delivery data CTE created earlier
GROUP BY 
    month_no  -- Group results by month number
ORDER BY 
    month_no;  -- Order results by month number
