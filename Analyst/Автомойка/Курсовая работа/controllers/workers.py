from app import app
from flask import render_template, request, session
from datetime import datetime, timedelta
#import sqlite3
from utils import get_db_connection
from models.workers_model import (get_workers, get_worker_name, get_dates, set_box_worker, get_worker_plan, 
                                  get_box_1_plan, get_box_2_plan, get_box_3_plan)

@app.route('/workers', methods=['get'])
def workers():
    conn = get_db_connection()
    worker_id = ""
    box_id = ""
    btn = 0
    if 'first_date' in session and 'second_date' in session:
        first_date = session['first_date']
        second_date = session['second_date']
    else:
        first_date = datetime.today().strftime("%Y-%m-%d")
        second_date = (datetime.today() + timedelta(days=6)).strftime("%Y-%m-%d")
        session['first_date'] = first_date
        session['second_date'] = second_date

    
    if request.values.get('btn'):
        btn = int(request.values.get('btn'))
        session['btn'] = btn
    if request.values.get('worker_id'):
        worker_id = int(request.values.get('worker_id'))
        session['worker_id'] = worker_id
    if request.values.get('box_id'):
        box_id = int(request.values.get('box_id'))
        session['box_id'] = box_id
    if request.values.get('first_date'):
        first_date = request.values.get('first_date')
        session['first_date'] = first_date
    if request.values.get('second_date'):
        second_date = request.values.get('second_date')
        session['second_date'] = second_date
    if request.values.get('btn') == '3':
        session['worker_id'] = ""
        session['box_id'] = ""
    if request.values.get('btn') == '2':
        session['box_id'] = ""

    df_workers = get_workers(conn)
    df_worker_name = get_worker_name(conn, worker_id)
    df_days = get_dates(conn, session['first_date'], session['second_date'])
    if request.values.get('worker_id') and request.values.get('box_id') and int(request.values.get('btn')) == 1:
        df_set_box_worker = set_box_worker(conn, first_date, second_date, worker_id, box_id)
    df_worker_plan = get_worker_plan(conn, worker_id, first_date, second_date)
    df_box_1_plan = get_box_1_plan(conn, first_date, second_date)
    df_box_2_plan = get_box_2_plan(conn, first_date, second_date)
    df_box_3_plan = get_box_3_plan(conn, first_date, second_date)

    html = render_template(
    'workers.html',
    workers_list = df_workers,
    worker_id = session.get('worker_id'), 
    box_id = session.get('box_id'),
    first_date = session.get('first_date'),
    second_date = session.get('second_date'),
    btn = session.get('btn'),
    worker_name = df_worker_name,
    days = df_days,
    worker_plan = df_worker_plan,
    box_1_plan = df_box_1_plan,
    box_2_plan = df_box_2_plan,
    box_3_plan = df_box_3_plan,
    len = len
    )

    return html