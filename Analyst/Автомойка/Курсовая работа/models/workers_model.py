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


def set_box_worker(conn, first_date, second_date, worker_id, box_id):
    cur = conn.cursor()

    # Check if records already exist
    cur.execute('''
    SELECT COUNT(*) 
    FROM box_worker 
    WHERE (worker_id = :b_worker_id OR box_id = :b_box_id) AND
          work_date >= :b_first_date AND work_date <= :b_second_date;
    ''', {"b_worker_id": worker_id, "b_box_id": box_id, "b_first_date": first_date, "b_second_date": second_date})
    count = cur.fetchone()[0]

    if count > 0:
        # Records already exist, return without inserting
        return

    # Records do not exist, perform the insertion
    cur.execute('''
    INSERT INTO box_worker (worker_id, box_id, work_date)
    WITH RECURSIVE date_range(work_date) AS (
        SELECT date(:b_first_date)
        UNION ALL
        SELECT date(work_date, '+1 day')
        FROM date_range
        WHERE work_date < date(:b_second_date)
    )
    SELECT :b_worker_id worker_id, :b_box_id box_id, work_date
    FROM date_range;
    ''', {"b_first_date": first_date, "b_second_date": second_date, "b_worker_id": worker_id, "b_box_id": box_id})
    conn.commit()


def get_worker_plan(conn, worker_id, first_date, second_date):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    SELECT *
    FROM box_worker
    WHERE worker_id = :b_worker_id AND ((work_date BETWEEN :b_first_date AND :b_second_date) OR
                       work_date = :b_first_date)
    ''', conn, params={"b_worker_id": worker_id, "b_first_date": first_date, "b_second_date": second_date})

def get_box_1_plan(conn, first_date, second_date):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    SELECT *, SUBSTR(worker_name, 1, INSTR(worker_name, ' ') - 1) AS worker_name_short
    FROM box_worker JOIN worker USING (worker_id)
    WHERE box_id = 1 AND (work_date BETWEEN :b_first_date and :b_second_date or work_date = :b_first_date)
    ORDER BY work_date
    ''', conn, params={"b_first_date": first_date, "b_second_date": second_date})

def get_box_2_plan(conn, first_date, second_date):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    SELECT *, SUBSTR(worker_name, 1, INSTR(worker_name, ' ') - 1) AS worker_name_short
    FROM box_worker JOIN worker USING (worker_id)
    WHERE box_id = 2 AND (work_date BETWEEN :b_first_date and :b_second_date or work_date = :b_first_date)
    ORDER BY work_date
    ''', conn, params={"b_first_date": first_date, "b_second_date": second_date})

def get_box_3_plan(conn, first_date, second_date):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    SELECT *, SUBSTR(worker_name, 1, INSTR(worker_name, ' ') - 1) AS worker_name_short
    FROM box_worker JOIN worker USING (worker_id)
    WHERE box_id = 3 AND (work_date BETWEEN :b_first_date and :b_second_date or work_date = :b_first_date)
    ORDER BY work_date
    ''', conn, params={"b_first_date": first_date, "b_second_date": second_date})