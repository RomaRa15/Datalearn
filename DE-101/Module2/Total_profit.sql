select round(sum(profit)) as Total_profit_2016
from orders o 
where date_part('year', order_date) = 2016;

select round(sum(profit)) as Total_profit_2017
from orders o 
where date_part('year', order_date) = 2017;

select round(sum(profit)) as Total_profit_2018
from orders o 
where date_part('year', order_date) = 2018;

select round(sum(profit)) as Total_profit_2019
from orders o 
where date_part('year', order_date) = 2019;

select round(sum(profit)) as Total_profit
from orders o;