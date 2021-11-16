select AVG(discount) as AVG_discount_2016
from orders o
where date_part('year', order_date) = 2016;

select AVG(discount) as AVG_discount_2017
from orders o
where date_part('year', order_date) = 2017;

select AVG(discount) as AVG_discount_2018
from orders o
where date_part('year', order_date) = 2018;

select AVG(discount) as AVG_discount_2019
from orders o
where date_part('year', order_date) = 2019;

select AVG(discount) as AVG_discount_all_time
from orders o;