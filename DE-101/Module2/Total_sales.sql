select round(sum(sales)) as Выручка_за_2016_год
from orders o 
where date_part('year', order_date) = 2016;

select round(sum(sales)) as Выручка_за_2017_год
from orders o 
where date_part('year', order_date) = 2017;

select round(sum(sales)) as Выручка_за_2018_год
from orders o 
where date_part('year', order_date) = 2018;

select round(sum(sales)) as Выручка_за_2019_год
from orders o 
where date_part('year', order_date) = 2019;

select round(sum(sales)) as Выручка_за_все_время
from orders o;
