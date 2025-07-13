#create table edata_clean as -- This is used to create new table
#select * from edata; -- as edata table. note: don't create another one.
use ecommerce;
select * from edata_clean;

#remove rows with blank description or customerIDs
delete from edata_clean
where description is null or trim(description) = ''
or customerid is null or trim(customerid) = '';

# let's create another table of the cancelled orders to preseve the data.

create table edata_cancelled as select * from edata 
where invoiceNo like 'C%'; # we have now preserved the cancelled orders data(rows)

#delete all rows of cancelled orders from the table we are clea
delete from edata_clean where invoiceNo like 'C%'; 

#remove exact duplicate rows

show columns from edata_clean;

#duplicate removal
create temporary table edata_deduped as
select *, row_number() over (partition by invoiceNo, Description,Quantity, InvoiceDate, unitprice,customerid, country
order by invoicedate) as R_No 
from edata_clean;

#so what actually happening is we assigning numbers to each row, if the same rows comes again
#R_No will become 2 for it and so on. so we will keep only 1st occurence of the rows and remove other.

#now lets delete the duplicates

delete from edata_clean; #remove all rows from edata_clean(main file)

#now insert the rows from edata_deduped, but only the 1st occurence
insert into edata_clean
select InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
from edata_deduped
where R_No = 1;

select count(*) from edata_clean; #count the remaining rows after cleaning.

select
 * 
from edata_clean;





















































