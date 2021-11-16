select date_part('year', order_date), category, sum(sales) as Sales, sum(profit) as Profit, round(sum(profit)/sum(sales),4) as Protit_ratio
from orders o 
group by date_part('year', order_date), category 
order by date_part('year', order_date);