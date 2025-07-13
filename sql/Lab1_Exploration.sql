select * from edata
limit 10;

# Null check
select
count(*) as total_rows,
sum(case when Description is null or trim(description) = '' then 1 else 0 end) as null_desc,
sum(case when CustomerID is null or trim(customerID) = '' then 1 else 0 end) as null_cID,
sum(case when InvoiceDate is null or trim(invoiceDate) = '' then 1 else 0 end) as null_invdate
from edata;

# find duplicates (by invoice + product)
select invoiceNo, stockCode, count(*) as occurences
from edata
group by invoiceNo, stockCode
having count(*) > 1
order by occurences desc
limit 20;

# Negative or zero quantities
select * from edata
where quantity <=0
order by quantity;

# top countries by orders
select country, count(distinct invoiceNo) as total_orders
from edata
group by country
order by total_orders desc
limit 50;

# top selling products
select Description, sum(quantity) as Total_sold
from edata
where description is not null
group by description
order by total_sold desc
limit 50;

# cancelled order

select * from edata
where invoiceNo like 'C%';

select count(*) from edata
where invoiceNo like 'C%';



































































































































