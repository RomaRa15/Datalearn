import pandas

def get_workers(conn):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    SELECT *
    FROM worker
    ''', conn)

def get_worker_name(conn, worker_id):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    SELECT *
    FROM worker
    WHERE worker_id = :b_worker_id
    ''', conn, params={"b_worker_id": worker_id})

def get_dates(conn, first_date, second_date):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    WITH RECURSIVE date_range(dt) AS (
    SELECT date(:b_first_date)
    UNION ALL
    SELECT date(dt, '+1 day')
    FROM date_range
    WHERE dt < date(:b_second_date)
    )
    SELECT dt FROM date_range;
    ''', conn, params={"b_first_date": first_date, "b_second_date": second_date})