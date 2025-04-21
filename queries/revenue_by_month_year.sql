-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

WITH a AS (
    SELECT 
        customer_id,  -- Select the customer ID for each order
        order_id,  -- Select the order ID for each order
        order_delivered_customer_date,  -- Select the date when the order was delivered
        order_status,  -- Select the status of the order
        strftime('%Y', order_delivered_customer_date) AS YEAR,  -- Extract the year from the delivery date
        strftime('%m', order_delivered_customer_date) AS MONTH,  -- Extract the month number from the delivery date
        payment_value  -- Select the payment value for each order
    FROM 
        olist_orders  -- From the 'olist_orders' table
    INNER JOIN 
        olist_order_payments USING (order_id)  -- Join with 'olist_order_payments' using order_id
    WHERE 
        order_status = 'delivered'  -- Filter for orders that have been delivered
        AND order_delivered_customer_date IS NOT NULL  -- Ensure that the delivery date is not null
    GROUP BY 
        order_id  -- Group results by order_id
    ORDER BY 
        order_delivered_customer_date ASC  -- Order results by delivery date in ascending order
)
SELECT 
    MONTH AS month_no,   -- Month number (01-12)
	CASE MONTH  -- Convert month number to abbreviated month name
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
    SUM (  -- Calculate the total payment value for the year 2016
        CASE
            WHEN YEAR = '2016' THEN payment_value
            ELSE 0
        END
    ) AS Year2016,  -- Alias the total as 'Year2016'
    SUM (  -- Calculate the total payment value for the year 2017
        CASE
            WHEN YEAR = '2017' THEN payment_value
            ELSE 0
        END
    ) AS Year2017,  -- Alias the total as 'Year2017'
    SUM (  -- Calculate the total payment value for the year 2018
        CASE
            WHEN YEAR = '2018' THEN payment_value
            ELSE 0
        END
    ) AS Year2018  -- Alias the total as 'Year2018'
FROM a  -- Use the common table expression 'a' created earlier
GROUP BY month_no, month  -- Group results by month number and month name
ORDER BY month_no;  -- Order results by month number


