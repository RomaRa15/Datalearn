# импорт объекта для создания приложения
from flask import Flask, session

# создание экземпляра объекта приложения
app = Flask(__name__)

# установим секретный ключ для подписи.
app.secret_key = 'b_5#y2L"F4Q8z\n\xec]/'

import controllers.index
import controllers.workers