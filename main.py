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
    if fmt.lower() == 'xml':
        xml = dicttoxml(data, custom_root='response'm attr_type=False)
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
def get_fruits():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM fruits')
    data = cur.fetchall()
    cur.close()

    return jsonify(data), 200

@app.route('/fruits/add')
def create_fruit(user_id):
    data = request.get_json()

    #add na lang ng logic here
    return jsonify(data), 200

if __name__ == '__main__':
    app.run(debug=True)
