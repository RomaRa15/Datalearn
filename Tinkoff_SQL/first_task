select name
from pilots p 
	 join flights f on p.pilot_id = f.second_pilot_id
where (date_part('year', f.flight_dt), date_part('month', f.flight_dt)) in (2021, August) and destination = 'Шереметьево'
