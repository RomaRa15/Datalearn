select order_id, sum(profit) as Profit, sum(sales) as Sales
from orders o 
group by order_id, order_date
order by  order_date asc;