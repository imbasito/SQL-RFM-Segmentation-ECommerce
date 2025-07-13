
/*
| Metric            | Definition                                                  |
| ----------------- | ----------------------------------------------------------- |
| Recency (R)   | How recently the customer purchased (days since last order) |
| Frequency (F) | How often they purchase (number of orders)                  |
| Monetary (M)  | How much they spend in total (£)                            |
*/

#Find the Latest Invoice Date in Dataset

SELECT
    MAX(invoiceDate) as MAX_Date    #this is the latest date we have
from edata_customer_type;

# Now we will find days since last purchase for each customer, 
# this is called recency.
#Recency

SELECT
    customerID,
    DATEDIFF('2011-07-06',MAX(invoiceDate)) as Recency
    #subtracting the last invoiceDate of each customer
    #from last date #2011-07-06 of purchase
    from edata_customer_type
    GROUP BY `CustomerID`
    ORDER BY Recency ASC;

#Recency
#Frequency
#Monetory
create or REPLACE VIEW edata_rfm as
SELECT
    customerID,
    DATEDIFF('2011-07-06',MAX(invoiceDate)) as Recency,
    Count(DISTINCT invoiceNo) as Frequency,
    ROUND(SUM(`Quantity`*`UnitPrice`),2) as Monetary
from edata_customer_type
GROUP BY `CustomerID`
order by Frequency desc;

SELECT
    *
FROM edata_rfm;
    -- Recency Score: Lower recency = higher score
    -- Frequency Score: more orders = higher score
    -- Monetary Score: higher spending = higher score
SELECT
    *,
    CASE 
        WHEN Recency <= 30 THEN 4
        WHEN Recency <= 60 THEN 3
        WHEN Recency <= 90 THEN 2
        ELSE  1
    END AS R_Score,

    CASE 
        WHEN Frequency >= 30 THEN 4 
        WHEN Frequency >= 20 THEN 3 
        WHEN Frequency >= 10 THEN 2 
        ELSE 1
    END AS F_Score,

    CASE 
        WHEN Monetary >= 10000 THEN 4 
        WHEN Monetary >= 5000 THEN 3 
        WHEN Monetary >= 1000 THEN 2 
        ELSE 1
    END AS M_Score
from edata_rfm;


-- Lets make Final RFM Table with Segments

CREATE or REPLACE view edata_rfm_segmented as
SELECT
    *,
    CASE 
        WHEN R_Score = 4 AND F_Score = 4 AND M_Score = 4 THEN 'Champions' 
        WHEN R_Score <=2 AND F_Score = 4 AND M_Score = 4 THEN 'Loyal but slipping' 
        WHEN R_Score = 1 AND F_Score = 1 AND M_Score = 1 THEN 'Lost' 
        WHEN R_Score = 4 AND F_Score = 1 AND M_Score = 1 THEN 'New Customers' 
        WHEN R_Score >= 4 AND F_Score >= 3 AND M_Score >= 3 THEN 'Loyal Customers' 
        WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score >= 3 THEN 'Big Spenders at Risk' 
        ELSE 'Others'  
    END AS RFM_Segment
    FROM (
        SELECT
        *,
        CASE 
            WHEN Recency <= 30 THEN 4
            WHEN Recency <= 60 THEN 3
            WHEN Recency <= 90 THEN 2
            ELSE  1
        END AS R_Score,

        CASE 
            WHEN Frequency >= 30 THEN 4 
            WHEN Frequency >= 20 THEN 3 
            WHEN Frequency >= 10 THEN 2 
            ELSE 1
        END AS F_Score,

        CASE 
            WHEN Monetary >= 10000 THEN 4 
            WHEN Monetary >= 5000 THEN 3 
            WHEN Monetary >= 1000 THEN 2 
            ELSE 1
        END AS M_Score
    from edata_rfm
    ) AS Scored;

-- now run the view/table
SELECT
    *
FROM edata_rfm_segmented;










