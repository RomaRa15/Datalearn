
select round(sum(profit)) as Total_profit_2016, round(sum(sales)) as Total_sales_2016,
round(round(sum(profit))/round(sum(sales)), 4) as Profit_ratio_2016
from orders o 
where date_part('year', order_date) = 2016;

select round(sum(profit)) as Total_profit_2017, round(sum(sales)) as Total_sales_2017,
round(round(sum(profit))/round(sum(sales)), 4) as Profit_ratio_2017
from orders o 
where date_part('year', order_date) = 2017;

select round(sum(profit)) as Total_profit_2018, round(sum(sales)) as Total_sales_2018,
round(round(sum(profit))/round(sum(sales)), 4) as Profit_ratio_2018
from orders o 
where date_part('year', order_date) = 2018;

select round(sum(profit)) as Total_profit_2019, round(sum(sales)) as Total_sales_2019,
round(round(sum(profit))/round(sum(sales)), 4) as Profit_ratio_2019
from orders o 
where date_part('year', order_date) = 2019;

select round(sum(profit)) as Total_profit,
round(sum(sales)) as Total_sales, round(round(sum(profit))/round(sum(sales)), 4) as Profit_ratio
from orders o;