#1. Сформировать расчетный лист заданному сотруднику в определенный месяц. 
WITH get_hours (worker_name, worker_id, date_report, wage, one_hours, double_hours) AS (
Select worker_name, worker_id, date_report, wage,
CASE 
	WHEN DAYOFWEEK(date_report) BETWEEN 2 AND 6 AND amount <=8 THEN amount
    WHEN DAYOFWEEK(date_report) BETWEEN 2 AND 6 AND amount > 8 THEN 8
    ELSE 0
END as one_hour,
CASE 
	When DAYOFWEEK(date_report) IN (1,7) THEN amount
    When DAYOFWEEK(date_report) BETWEEN 2 AND 6 AND amount > 8 THEN amount - 8
    ELSE 0
END as double_hour
From worker JOIN report USING(worker_id)
			JOIN position USING(position_id)
),
get_month_salary (month, worker_name, worker_id, month_salary) AS (
Select MONTH(date_report), worker_name, worker_id, SUM(wage*one_hours)+SUM(2*wage*double_hours)
From get_hours
GROUP BY MONTH(date_report), worker_name
),
get_oklad (month, worker_id, bonus_id, sum) AS (
SELECT month, worker_id, bonus_id, month_salary
FROM bonus JOIN worker_bonus USING(bonus_id)
		   JOIN get_month_salary USING(worker_id)
WHERE bonus_name LIKE '%Оклад%' AND month = 3 AND month_end IS NULL
),
get_fix (month, worker_id, bonus_id, sum) AS (
SELECT month, worker_id, bonus_id, 
CASE 
	WHEN measure = 1 THEN month_salary*total/100
    ELSE total
END as sum
FROM bonus JOIN worker_bonus USING(bonus_id)
		   JOIN get_month_salary USING(worker_id)
WHERE bonus_name = 'Фиксированная надбавка' AND month = 3 AND month_end IS NULL
),
get_salary_fix (month, worker_id, worker_name, month_salary, month_salary_fix) AS (
SELECT get_month_salary.month, worker_id, worker_name, month_salary, month_salary + IFNULL(sum,0)
FROM get_month_salary LEFT JOIN get_fix USING(worker_id)
WHERE get_month_salary.month = 3
),
get_koef (month, worker_id, bonus_id, sum) AS (
SELECT month, worker_id, bonus_id, 
CASE 
	WHEN measure = 1 THEN ROUND(month_salary_fix * total/100,2)
    ELSE total
END as sum
FROM bonus JOIN worker_bonus USING(bonus_id)
		   JOIN get_salary_fix USING(worker_id)
WHERE bonus_name NOT IN ('Фиксированная надбавка', 'Оклад за часы', 'Подоходный налог', 'З\П на руки') AND month = 3 AND month_end IS NULL
),
get_prep_nalog (worker_id, month, sum) AS (
SELECT worker_id, get_koef.month, (SUM(month_salary_fix)/COUNT(month_salary_fix))+sum(sum)
FROM get_salary_fix JOIN get_koef USING(worker_id)
GROUP BY worker_id, month
),
get_nalog (month, worker_id, bonus_id, sum) AS (
SELECT month, worker_id, bonus_id,
CASE
	WHEN measure = 1 THEN -(sum - dependant*1400) * total/100
    ELSE -total
END as sum
FROM 
get_prep_nalog JOIN worker_bonus USING(worker_id)
			   JOIN bonus USING(bonus_id)
               JOIN worker USING(worker_id)
WHERE bonus_name LIKE '%Налог%'
),
get_list (month, worker_id, bonus_id, sum) AS (
SELECT *
FROM get_oklad
UNION
SELECT *
FROM get_koef
UNION
SELECT *
FROM get_fix
UNION
SELECT *
FROM get_nalog
)

SELECT YEAR(now()) year, month, worker_id, bonus_id, ROUND(sum,2) sum
FROM get_list
WHERE worker_id = 1
UNION
SELECT YEAR(now()) year, month, worker_id, worker_bonus.bonus_id, ROUND(SUM(sum),2) sum
FROM get_list JOIN worker_bonus USING(worker_id)
GROUP BY YEAR(now()), month, worker_id, bonus_id
HAVING bonus_id = 7 AND worker_id = 1
ORDER BY worker_id, bonus_id;

SELECT year, month, worker_name, bonus_name, sum
FROM pay_sheet JOIN bonus USING(bonus_id)
			   JOIN worker USING(worker_id)
WHERE worker_id = 1

#2. Некоторый сотрудник собирается работать в ближайшее воскресенье.
#Занести новую запись в таблицу (количество часов, название надбавки и сумму
#не заполнять).
INSERT INTO report (worker_id, date_report, amount)
SELECT worker_id, DATE(DATE_ADD(NOW(),INTERVAL (8 - DAYOFWEEK(NOW())) DAY)) date_report, 0 amount
FROM worker
WHERE worker_name LIKE '%Сидорова%'

#3. Поднять ставку оплаты на 10% для некоторой должности.
UPDATE position
SET wage = wage*1.1
WHERE position_name LIKE '%Маркетолог%'
