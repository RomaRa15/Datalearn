select date_part('year', order_date), sum(sales) as Total_sales, sum(profit) as Total_profit, round(sum(profit)/sum(sales), 4) as Profit_ratio
from orders o
group by date_part('year', order_date)
order by date_part('year', order_date) asc;