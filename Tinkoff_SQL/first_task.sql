-- Задача 1. Напишите запрос, который выведет пилотов, которые в качестве второго пилота в
-- августе этого года ездили в аэропорт Шереметьево. 

select name
from pilots p 
	 join flights f on p.pilot_id = f.second_pilot_id
where date_part('year', f.flight_dt) = 2021 and 
      date_part('month', f.flight_dt) = 8 and 
      destination = 'Шереметьево';
