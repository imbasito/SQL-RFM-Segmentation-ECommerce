# total revenue
select
round(sum(quantity * unitprice),2) as Total_Revenue
from edata_clean
order by Total_Revenue desc;

# top products by revenue
select
Description as Product,
round(sum(quantity * unitprice),2) as Revenue
from edata_clean
group by Description
order by Revenue desc;

#top countries by revenue (excluding UK)
select
Country,
round(sum(quantity * unitprice),2) as Revenue
from edata_clean
group by Country
having Country<> 'United Kingdom'
order by Revenue desc;

# modifying top countries revenue with Extra insights

select
	(select round(sum(Revenue),2)
		from(select
				Country,
				sum(quantity * unitprice) as Revenue
			from edata_clean
			group by Country
			having Country<> 'United Kingdom'
			order by Revenue desc
	) as sub) as Non_UK,
	(select round(sum(Revenue),2)
		from(select
				Country,
				sum(quantity * unitprice) as Revenue
            from edata_clean
            group by country
            having country = 'United Kingdom'
	) as sub) as UK;
    
#alternative method
select 
sum(case when country <> 'United Kingdom' then Quantity*unitprice else 0 end) as Non_UK_Revenue,
sum(case when country = 'United Kingdom' then quantity * unitprice else 0 end) as UK_Revenue
from edata_clean;

#filtering countries above threshold
select
country,
round(sum(quantity * unitprice),2) as Revenue
from edata_clean
group by country
having sum(quantity * unitprice) > 5000
order by revenue desc;

#top customers
select 
CustomerID,
round(sum(quantity * unitprice),2) as Revenue
from edata_clean
group by customerID
order by Revenue desc;

# monthly revenue trends
select 
	date_format(invoiceDate, '%Y-%m') Date,
	round(sum(quantity * unitprice),2) as Revenue
from edata_clean
group by date_format(invoiceDate, '%Y-%m')
order by date;
























































