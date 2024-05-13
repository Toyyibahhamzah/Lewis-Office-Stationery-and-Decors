--QUE 1

--How much revenue did we generate from each product category, 
--after considering a 10% discount for products that cost more than $100, 
--and a 5% discount for products that cost between $50 and $100?

SELECT "ProductCategory",
		sum(CASE
		   		when "Price" > 100 then "Price" * 0.9 * "Quantity"
		   		when "Price" between 50 and 100 then "Price" * 0.95 * "Quantity"
		   		else "Price" * "Quantity"
		   end) as "discounted revenue"
from orders
join products ON products."ProductID" = orders."ProductID"
group by "ProductCategory";

SELECT "ProductCategory",
		sum("Price" * "Quantity") as Revenue
from orders
join products ON products."ProductID" = orders."ProductID"
group by "ProductCategory";


--QUE 2

--What is the total revenue generated, 
--considering that products with a NULL price should be treated as having a default price of $10?

SELECT sum(COALESCE("Price", 10) * "Quantity")
from orders
join products on orders."ProductID" = products."ProductID";

SELECT sum(COALESCE(products."Price", 10) * orders."Quantity") as "Total revenue"
from orders
join products on orders."ProductID" = products."ProductID";



--QUE 3

--How many orders were placed in the year 2015?

SELECT count(distinct "OrderID")
from orders
where cast("OrderDate" as date) between '2015-01-01' and '2015-12-31';


--QUE 4

--What is the name and category of the top-selling product (in terms of quantity) in the year 2015?

SELECT p."ProductName", p."ProductCategory", sum(o."Quantity"), o."OrderDate"
from products p
join orders o on o."ProductID" = p."ProductID"
where o."OrderDate" between '2015-01-01' and '2015-12-31'
group by p."ProductName", p."ProductCategory", o."OrderDate"
order by sum(o."Quantity") desc
limit 1;

SELECT p."ProductName", p."ProductCategory"
FROM products p
JOIN (
    SELECT "ProductID"
    FROM orders
    WHERE "OrderDate" between '2015-01-01' and '2015-12-31'
    GROUP BY "ProductID"
    ORDER BY SUM("Quantity") DESC
    LIMIT 1
) AS top_product ON p."ProductID" = top_product."ProductID";



--What is the average price of products that have never been ordered?

SELECT avg("Price")
from products
WHERE "ProductID" not in (
	select distinct "ProductID" from orders
);


select
	coalesce(
		CAST(avg("Price") as text),
		'All products were ordered')
from products
WHERE "ProductID" not in (
	select distinct "ProductID" from orders
);
		