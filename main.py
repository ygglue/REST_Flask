from flask import Flask, request, jsonify, make_response
from flask_mysqldb import MySQL
from dicttoxml import dicttoxml
from flask_jwt_extended import (
    JWTManager, create_access_token, jwt_required, get_jwt_identity
)
import re
from config import Config

app = Flask(__name__)
app.config.from_object(Config)

mysql = MySQL(app)
jwt = JWTManager(app)

#HELPER FUCTIONS
def to_format(data, fmt):
    if fmt and fmt.lower() == 'xml':
        xml = dicttoxml(data, custom_root='response', attr_type=False)
        response = make_response(xml)
        response.headers['Content-Type'] = 'application/xml'
        return response
    else:
        response = make_response(jsonify(data))
        response.headers['Content-Type'] = 'application/json'
        return response

def validate_int(val):
    try:
        return int(val)
    except:
        return None

def fetchone(query, args=()):
    cur = mysql.connection.cursor()
    cur.execute(query, args)
    rv = cur.fetchone()
    cur.close()
    return rv

def fetchall(query, args=()):
    cur = mysql.connection.cursor()
    cur.execute(query, args)
    rv = cur.fetchall()
    cur.close()
    return rv


# MAIN

@app.route('/')
def home():
    return 'Hello!'

@app.route('/fruits', methods=['GET'])
@jwt_required(optional=True)
def get_fruits():
    fmt = request.args.get('format')
    q = request.args.get('q')
    if q:
        qlike = f'%{q}%'
        rows = fetchall("SELECT * FROM fruits WHERE name LIKE %s OR acquired_from LIKE %s", (qlike, qlike))
    else:
        rows = fetchall('SELECT * FROM fruits')
    return to_format({'fruits': rows}, fmt)

@app.route('/fruits/<int:item_id>', methods=['GET'])
@jwt_required(optional=True)
def get_fruit(item_id):
    fmt = request.args.get('format')
    row = fetchone("SELECT * FROM fruits WHERE id=%s", (item_id,))
    if not row:
        return jsonify({"msg": "Not Found"}), 404
    return to_format({"fruits": row}, fmt)

if __name__ == '__main__':
    app.run(debug=True)
