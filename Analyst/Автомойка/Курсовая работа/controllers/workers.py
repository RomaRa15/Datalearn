from app import app
from flask import render_template, request, session
from datetime import datetime, timedelta
#import sqlite3
from utils import get_db_connection
from models.workers_model import (get_workers, get_worker_name, get_dates)

@app.route('/workers', methods=['get'])
def workers():
    conn = get_db_connection()
    worker_id = ""
    box_id = ""
    first_date = datetime.today().strftime("%Y-%m-%d")
    second_date = (datetime.today() + timedelta(days=6)).strftime("%Y-%m-%d")
    
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

    df_workers = get_workers(conn)
    df_worker_name = get_worker_name(conn, worker_id)
    df_days = get_dates(conn, first_date, second_date)

    html = render_template(
    'workers.html',
    workers_list = df_workers,
    worker_id = session.get('worker_id'), 
    box_id = session.get('box_id'),
    first_date = first_date,
    second_date = second_date,
    worker_name = df_worker_name,
    days = df_days,
    len = len
    )

    return html