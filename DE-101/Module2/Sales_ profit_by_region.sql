select region, sum(sales) as Sales, sum(profit) as Profit, round(sum(profit)/sum(sales), 4) as Profit_ratio
from orders o 
group by region;