import pandas

def get_car_type(conn):
    # выводим доступные типы авто
    return pandas.read_sql('''
    SELECT *
    FROM car_type
    ''', conn)


def get_services_for_car(conn, car_type_id):
    # выбираем и выводим записи о том, какие книги брал читатель
    return pandas.read_sql('''
    SELECT service_id, service_name, price, time_need
    FROM car_type JOIN car_service USING(car_type_id)
			  JOIN service USING (service_id)
    WHERE car_type_id = :b_car_type_id
    ''', conn, params={"b_car_type_id": car_type_id})


def get_calc(conn, car_type_id, service_id):
    if service_id is None:
        service_id = []

    sql_query = '''
        SELECT SUM(price), SUM(time_need), CAST(ROUND(SUM(time_need)/15 + 0.5) AS INTEGER) slot
        FROM car_type
        JOIN car_service USING(car_type_id)
        JOIN service USING(service_id)
        WHERE car_type_id = :b_car_type_id
        AND service_id IN ({})
    '''.format(', '.join([':b_service_id{}'.format(i) for i in range(len(service_id))]))

    params = {"b_car_type_id": car_type_id}
    params.update({"b_service_id{}".format(i): value for i, value in enumerate(service_id)})

    return pandas.read_sql(sql_query, conn, params=params)


def get_time_box_1(conn, my_date):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    SELECT *
    FROM time_slot JOIN time_table USING(time_id)
                    JOIN box_worker USING(box_worker_id)
                    LEFT JOIN order_list USING(order_id)
                    LEFT JOIN client USING (client_id)
    WHERE box_id = 1 AND work_date = :b_my_date
    ''', conn, params={"b_my_date": my_date})


def get_time_box_2(conn, my_date):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    SELECT *
    FROM time_slot JOIN time_table USING(time_id)
			    JOIN box_worker USING(box_worker_id)
                LEFT JOIN order_list USING(order_id)
			    LEFT JOIN client USING (client_id)
    WHERE box_id = 2 AND work_date = :b_my_date
    ''', conn, params={"b_my_date": my_date})


def get_time_box_3(conn, my_date):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    SELECT *
    FROM time_slot JOIN time_table USING(time_id)
			    JOIN box_worker USING(box_worker_id)
                LEFT JOIN order_list USING(order_id)
			    LEFT JOIN client USING (client_id)
    WHERE box_id = 3 AND work_date = :b_my_date
    ''', conn, params={"b_my_date": my_date})


def get_client_list(conn):
    # выводим список клиентов
    return pandas.read_sql('''
    SELECT *
    FROM client
    ORDER BY client_name
    ''', conn)


def get_add_client(conn, client_name, car_number, client_phone):
    cur = conn.cursor()
    cur.execute('''
    INSERT INTO client (client_name, client_phone, car_model, car_number)
    SELECT :b_client_name, :b_client_phone, "", :b_car_number
    WHERE NOT EXISTS (
        SELECT 1
        FROM client
        WHERE client_name = :b_client_name
        AND car_number = :b_car_number
    )
    ''', {"b_client_name": client_name, "b_client_phone": client_phone, "b_car_number": car_number})
    conn.commit()


def get_new_order(conn, client_name, car_number):
    cur = conn.cursor()
    cur.execute('''
    INSERT INTO order_list (client_id)
    SELECT client_id
    FROM client 
    WHERE client_name LIKE ? and car_number LIKE ?
    ''', ('%' + client_name + '%', '%' + car_number + '%'))
    conn.commit()


def get_add_services_to_order(conn, car_type_id, service_id):
    cur = conn.cursor()
    last_order_id = cur.execute('SELECT order_id FROM order_list ORDER BY order_id DESC LIMIT 1').fetchone()[0]

    placeholders = ','.join(['?'] * len(service_id))
    query = '''
        INSERT INTO many_services (car_service_id, order_id)
        SELECT car_service_id, ? 
        FROM car_type
        JOIN car_service USING (car_type_id)
        JOIN service USING (service_id)
        WHERE car_type_id = ?
        AND service_id IN ({});
    '''.format(placeholders)

    values = [last_order_id, car_type_id] + service_id
    cur.execute(query, values)

    conn.commit()


def get_update_time_table(conn, time_slot_id):
    cur = conn.cursor()
    last_order_id = cur.execute('SELECT order_id FROM order_list ORDER BY order_id DESC LIMIT 1').fetchone()[0]

    placeholders = ','.join(['?'] * len(time_slot_id))
    query = '''
        UPDATE time_slot 
        SET order_id = ?
        WHERE time_slot_id IN ({});
    '''.format(placeholders)

    values = [last_order_id] + time_slot_id
    cur.execute(query, values)

    conn.commit()


def get_free_slot(conn, my_date, sum_time):
    # выбираем и выводим записи о бронированиях
    return pandas.read_sql('''
    WITH qq (time_slot_id, box_worker_id, order_id, box_id, slot_free) AS (
            SELECT time_slot_id, box_worker_id, order_id, box_id, COUNT(order_id) OVER win_list
            FROM time_slot JOIN time_table USING(time_id)
                        JOIN box_worker USING(box_worker_id)
            WHERE work_date = :b_my_date
            Window win_list AS (
            PARTITION BY box_id
            ORDER BY time_slot_id
            )
        ),
        prep_table AS (
        SELECT time_slot_id, box_worker_id, order_id, COUNT(slot_free) OVER win_list * 15 as slot_free
        FROM qq
        WHERE order_id ISNULL
        WINDOW win_list AS (
        PARTITION BY box_id, slot_free
        )
        )

        SELECT *
        FROM prep_table
        WHERE :b_sum_time <= slot_free
    ''', conn, params={"b_my_date": my_date, "b_sum_time": sum_time})