select round(sum(sales)) as �������_��_2016_���
from orders o 
where date_part('year', order_date) = 2016;

select round(sum(sales)) as �������_��_2017_���
from orders o 
where date_part('year', order_date) = 2017;

select round(sum(sales)) as �������_��_2018_���
from orders o 
where date_part('year', order_date) = 2018;

select round(sum(sales)) as �������_��_2019_���
from orders o 
where date_part('year', order_date) = 2019;

select round(sum(sales)) as �������_��_���_�����
from orders o;
