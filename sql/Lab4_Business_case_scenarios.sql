# CONFIRM THE DROP (COMPARE TO JUNE)
#Filter for just june 2011 and july 2011

#Scenario_1
select
    round(sum(quantity * unitprice),2) as Revenue_June_July
from edata_clean
where InvoiceDate 
between '2011-06-01' and '2011-07-31';

#alternative for clarification or comparison

select
	 (select Revenue_June
		from 
			(select
				round(sum(quantity * unitprice),2) as Revenue_June
			from edata_clean
			where invoiceDate between '2011-06-01' and '2011-06-30'
			) as sub_1) as June,
			
	(select Revenue_July 
		from 
			(select
				round(sum(quantity * unitprice),2) as Revenue_July
			from edata_clean
			where invoiceDate between '2011-07-01' and '2011-07-31'
			) as sub_2) as July;

#simpler method with case
select 
	round(sum(case when invoiceDate between '2011-06-01' and '2011-06-30' then quantity * unitprice else 0 end),2) as June,
    round(sum(case when invoiceDate between '2011-07-01' and '2011-07-31' then quantity * unitprice else 0 end),2) as July
from edata_clean;

# now lets find out why that much drop in july
# what sold in july

select description as Products,
	round(sum(quantity * unitprice),2) as Revenue,
    date_format(InvoiceDate, '%Y-%m-%d') as Date
from edata_clean
where date_format(InvoiceDate, '%Y-%m-%d') between '2011-07-01' and '2011-07-31'
group by description, date_format(InvoiceDate, '%Y-%m-%d')
order by Revenue desc;

/*🧐 Analysis Insight:
Sales were clustered around July 4th
Very few products dominated revenue
The rest of the month seems inactive
This might mean:
Limited operations during July
System outage?
Major customer(s) stopped ordering?
Warehouse closure or holiday?*/
#-------------------------------------------------------
#lets find how many orders were made in june and july to compare.

#june
select
count(distinct invoiceNo)
from edata_clean
where date_format(InvoiceDate, '%Y-%m-%d') between '2011-06-01' and '2011-06-30';

#july
select
count(distinct invoiceNo)
from edata_clean
where date_format(InvoiceDate, '%Y-%m-%d') between '2011-07-01' and '2011-07-31';

#alternative method
select 
count(case when date_format(InvoiceDate, '%Y-%m-%d') between '2011-06-01' and '2011-06-30' then invoiceNo else null end) as June,
count(case when date_format(invoiceDate, '%Y-%m-%d') between '2011-07-01' and '2011-07-31' then invoiceNo else null end) as July
from edata_clean;

# check if top customers from earlier went inactive

select 
count(distinct customerID)
from edata_clean	
where invoiceDate between '2011-06-01' and '2011-06-30' and customerID is not NULL;

select 
count(distinct customerID)
from edata_clean	
where invoiceDate between '2011-07-01' and '2011-07-31' and customerID is not NULL;

#alternative method
SELECT DISTINCT CustomerID
FROM edata_clean
WHERE
    InvoiceDate BETWEEN '2011-06-01' AND '2011-06-30' -- Customers active in June
    AND CustomerID IS NOT NULL -- Exclude rows without a customer ID
    AND CustomerID NOT IN (
        SELECT DISTINCT CustomerID
        FROM edata_clean
        WHERE InvoiceDate BETWEEN '2011-07-01' AND '2011-07-31' -- Customers active in July
        AND CustomerID IS NOT NULL
    );


#Senario_2:Product Returns & Refund Patterns
/*The Case:
Your manager says:
“We’ve noticed a lot of returns lately. Some products are coming back more than others. 
Can you investigate what’s being returned the most, how often, and how it’s impacting revenue?”*/

SELECT *
from edata_cancelled
where `InvoiceNo` LIKE 'C%';

#how many return transactions are there?

SELECT
COUNT(DISTINCT invoiceNo) as Returned_invoices,
COUNT(*) as Total_products_Returned
from edata_cancelled;

SELECT
DESCRIPTION,
abs(sum(quantity)) as Return_Amount
from edata_cancelled
GROUP BY `Description`
order by return_amount desc
LIMIT 10;

SELECT
round(sum(`UnitPrice` * `Quantity`)) as Total_Return_Amount
from edata_cancelled;


#Scenario_3: Profit Margin leak detection
/*The Case:
“Some of our products are making very little or no profit. 
 A few might even be selling below cost. We suspect a margin leak.
 Can you identify low or negative-margin products?” */

#first lets assume 70% cost price

CREATE OR REPLACE VIEW edata_margin AS
SELECT
*,
round((`UnitPrice` * 0.70),2) as Cost_Price,
round((`UnitPrice`-(`UnitPrice`* 0.70)),2) as Profit,
round((`UnitPrice`-(`UnitPrice`* 0.70)*`Quantity`),2) as Total_Profit
from edata_clean;


# Now lets find less than or equal to 0.10 Profit products or 0 profit
# also sold more than once

SELECT
DESCRIPTION,
ROUND(sum(`Quantity`),2) as Units_sold,
ROUND(sum(total_profit),2) as Total_profit
from edata_margin
WHERE `Profit` <= 0.10
GROUP BY `Description`
HAVING Units_sold > 1
ORDER BY Total_profitF
limit 20;


#Scenario_4: New vs Returning Customer Analysis
/*Why This Matters:
Businesses love growth. But growth from new customers means marketing
is working. Growth from returning customers means loyalty is strong.

This analysis shows how many buyers come back — 
and how valuable they are.*/

#First Purchase Date per customer
CREATE or REPLACE VIEW customer_first_order as
SELECT
	customerID,
	MIN(invoiceDate) as First_Purchase_Date
from edata_clean
WHERE `CustomerID` is NOT NULL
GROUP BY `CustomerID`;
#it won't produce output, it only creates the temporary table

#Step 2: Tag Orders as New vs. Returning
CREATE or REPLACE VIEW edata_customer_type AS
SELECT
	e.*,
	c.First_Purchase_Date,
	CASE 
		WHEN DATE(e.invoiceDate) = date(c.`First_Purchase_Date`) 
		THEN 'New' 
		ELSE  'Returning'
	END as CustomerType
from edata_clean e 
join customer_first_order c on e.`CustomerID`= c.`customerID`;

#now compare new vs returning customers

SELECT
	CustomerType,
	COUNT(DISTINCT invoiceNo) as Total_orders,
	COUNT(DISTINCT customerID) as Unique_customers,
	ROUND(SUM(quantity *unitprice),2) as Total_Revenue
from edata_customer_type
GROUP BY `CustomerType`

# Bonus step: Average Order Value (AOV) & Repeat Behavior
/* This helps you understand:
How much customers spend per order (AOV)
Whether returning customers buy more per order
If retention efforts are paying off */

#average order value(AOV), AOV = total-revenue/total_orders

SELECT
	CustomerType,
	COUNT(DISTINCT invoiceNo) as Total_orders,
	ROUND(sum(quantity * unitprice),2) as Total_revenue,
	ROUND(sum(quantity * unitprice) / COUNT(DISTINCT invoiceNo),2) as AOV 
from edata_customer_type
GROUP BY `CustomerType`;

# Final Scenario_4: Repeat Purchase Rate

SELECT
	`CustomerID` as Customer,
	COUNT(distinct invoiceNo) as Orders
from edata_customer_type
group by `CustomerID`
ORDER BY orders desc;

# now lets calculate the Repeat Purchase Rate

SELECT
	SUM(case when Orders = 1 then 1 else 0 end) AS oneTime_Buyers,
	SUM(case when Orders >= 2 then 1 else 0 end) as Repeated_Buyers,
	count(*) as Total_orders,
	ROUND(SUM(case when orders>=2 then 1 else 0 end)/count(*) * 100, 2) as RepeatRate_Percentage
from(
	SELECT
	`CustomerID` as Customer,
	COUNT(distinct invoiceNo) as Orders
from edata_customer_type
group by `CustomerID`
ORDER BY orders desc) as Customer_orders;

