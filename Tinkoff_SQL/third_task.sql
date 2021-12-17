

-- Задача 3. Выведите ТОП 10 пилотов-капитанов (first_pilot_id), которые перевезли наибольшее
-- число пассажиров в этом году.

-- Замечу, что в теории, у некоторых пилотов, может быть одинаковое количество перевезенных пассажиров за год. 
-- Например, у пилота, который в топе будет на 10 месте, одинаковое кол-во пассажиров с 11 и 12 местом в топе, тогда наш рейтинг будет не точным. 
-- Limit 10 просто скроет пилотов, которые на 11 и 12 местах.

select p2.name, sum(quantity) as sum
from flights f
	 join planes p on f.plane_id = p.plane_id 
	 join pilots p2 on f.first_pilot_id = p2.pilot_id 
where p.cargo_flg = 0 and date_part('year', flight_dt) = 2021
group by p2.name
limit 10;

-- Для того, чтобы точно вывести всех людей, которые по пассажироперевозкам входят в топ 10, можно использовать следующий запрос
-- 1. Сначала составляем список из 10 пилотов 
-- 2. Узнаем, какое кол-во пассажиров перевез пилот, занимаемый 10 место 
-- 3. Выводим топ пилотов в соответствии с минимальным кол-ом пассажиров за год (10 место в топе в п.1)

select p2.name, sum(quantity) as sum
from flights f
	 join planes p on f.plane_id = p.plane_id 
	 join pilots p2 on f.first_pilot_id = p2.pilot_id 
where p.cargo_flg = 0 and date_part('year', flight_dt) = 2021
group by p2.name
having sum(quantity) >= (select MIN(sum)
from 
(select sum(quantity) as sum
from flights f
	 join planes p on f.plane_id = p.plane_id 
	 join pilots p2 on f.first_pilot_id = p2.pilot_id 
where p.cargo_flg = 0 and date_part('year', flight_dt) = 2021
group by p2.name
order by sum(quantity) desc 
limit 10) a)
order by sum(quantity) desc 
