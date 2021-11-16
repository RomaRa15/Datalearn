select customer_name, sum(sales) as sales , sum(profit) as profit 
from orders o 
group by customer_name
order by customer_name asc;