-- Задача 2. Выведите пилотов старше 45 лет, которые совершили больше 30 полетов на грузовых самолетах.

select pilot_id_un, count(pilot_id_un) 
from 
(select first_pilot_id as pilot_id_un
from flights f
	 join planes p2 on f.plane_id = p2.plane_id 
where p2.cargo_flg = 1 
union all
select second_pilot_id
from flights f
	 join planes p2 on f.plane_id = p2.plane_id 
where p2.cargo_flg = 1) a join pilots p on a.pilot_id_un = p.pilot_id -- cargo_flg = 1 (на грузовых самолетах)
where p.age > 45 -- старше 45 лет
group by pilot_id_un
having count(pilot_id_un) > 30; -- совершили больше 30 полетов
