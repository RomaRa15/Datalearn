from app import app
from flask import render_template, request, session
from datetime import date, datetime
#import sqlite3
from utils import get_db_connection
from models.index_model import (get_car_type, get_services_for_car, get_calc, get_time_box_1, get_time_box_2, get_time_box_3, 
                                get_client_list, get_add_client, get_new_order, get_add_services_to_order, get_update_time_table,
                                get_free_slot)

#Нужно добавить сессию, чтобы не пропали данные после отправки другой формы
@app.route('/', methods=['get'])
def index():
    conn = get_db_connection()
    car_type_id = ""
    # список из номеров выбранных пользователем услуг
    service_id = []
    # дата
    session['my_date'] = date.today().strftime("%Y-%m-%d")
    client_name = ""
    session['client_name'] = ""
    car_number = ""
    client_phone = ""
    slot_id = []
    client_old = ""

    # нажата кнопка отчистить
    if request.values.get('reset'):
        session['car_type_id'] = ""
        session['service_id'] = []
        session['my_date'] = date.today().strftime("%Y-%m-%d")
    else:
        if request.values.get('car_type_id'):
            car_type_id = int(request.values.get('car_type_id'))
            session['car_type_id'] = car_type_id
        if request.values.getlist('services[]'):
            service_id = list(map(int, request.values.getlist('services[]')))
            session['service_id'] = service_id
        if request.values.get('my_date'):
            my_date = request.values.get('my_date')
            session['my_date'] = my_date

    if request.values.get('slot_id'):
        slot_id = list(map(int, request.values.getlist('slot_id')))
    if request.values.get('client_old'):
        client_old = tuple(request.values.get('client_old').split(','))  # Assuming the values are comma-separated
    if request.values.get('client_old'):
        client_old = tuple(request.values.get('client_old').split(','))
        client_name = client_old[0].strip("('\" ")
        car_number = client_old[1].strip(")'\" ")
    else:
        if request.values.get('client_name'):
            client_name = request.values.get('client_name')
        if request.values.get('car_number'):
            car_number = request.values.get('car_number')
        if request.values.get('client_phone'):
            client_phone = request.values.get('client_phone')

    df_car_type = get_car_type(conn)
    df_services_for_car = get_services_for_car(conn, session.get('car_type_id'))
    df_calc = get_calc(conn, session.get('car_type_id'), session.get('service_id'))
    df_add_client = ""
    df_new_order = ""
    df_add_services_to_order = ""
    df_update_time_table = ""
    if request.values.get('client_name'):
        df_add_client = get_add_client(conn, client_name, car_number, client_phone)
    if request.values.get('bron') and client_name != "" and car_number != "":
        df_new_order = get_new_order(conn, client_name, car_number)
        df_add_services_to_order = get_add_services_to_order(conn, session.get('car_type_id'), session.get('service_id'))
        df_update_time_table = get_update_time_table(conn, slot_id)
    time_need = df_calc.iloc[0]['SUM(time_need)']
    if time_need is not None:
        time_need = int(time_need)
    else:
        time_need = 0
    df_free_slot = get_free_slot(conn, session.get('my_date'), time_need)
    df_time_box_1 = get_time_box_1(conn, session.get('my_date'))
    df_time_box_2 = get_time_box_2(conn, session.get('my_date'))
    df_time_box_3 = get_time_box_3(conn, session.get('my_date'))
    df_client_list = get_client_list(conn)
    
    
   # выводим форму
    html = render_template(
    'index.html',
    car_type = df_car_type,
    car_type_id = session.get('car_type_id'),
    services_for_car = df_services_for_car,
    service_id = session.get('service_id', []),
    my_date = session.get('my_date'),
    calc = df_calc,
    time_box_1 = df_time_box_1,
    time_box_2 = df_time_box_2,
    time_box_3 = df_time_box_3,
    slot_id = slot_id,
    client_list = df_client_list,
    client_name = client_name,
    car_number = car_number,
    client_phone = client_phone,
    add_client = df_add_client,
    new_order = df_new_order,
    add_services_to_order = df_add_services_to_order,
    update_time_table = df_update_time_table,
    free_slot = df_free_slot,
    len = len
    )

    return html