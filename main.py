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

DEMO_USER = {"username": "admin", "password": "admin"}

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json() or {}
    username = data.get("username")
    password = data.get("password")
    if username == DEMO_USER["username"] and password == DEMO_USER["password"]:
        access_token = create_access_token(identity=username)
        return jsonify(access_token=access_token), 200
    return jsonify({"msg": "Bad credentials"}), 401

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

def validate_fruit_payload(payload, partial=False):
    errors = []
    if not partial:
        if "name" not in payload:
            errors.append("name is required")
        if "category_id" not in payload:
            errors.append("category_id is required")
    if "name" in payload and (not isinstance(payload["name"], str) or not payload["name"].strip()):
        errors.append("name must be a non-empty string")
    if "is_rotten" in payload:
        if payload["is_rotten"] not in (0, 1, "0", "1", True, False):
            errors.append("is_rotten must be a boolean/int 0 or 1")
    if "is_ripe" in payload:
        if payload["is_ripe"] not in (0, 1, "0", "1", True, False):
            errors.append("is_rotten must be a boolean/int 0 or 1")
    if "category_id" in payload:
        if validate_int(payload["category_id"]) is None:
            errors.append("category_id must be integer")
    return errors

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


@app.route('/fruits', methods=['POST'])
@jwt_required()
def create_fruit():
    payload = request.get_json() or {}
    errors = validate_fruit_payload(payload, partial=False)
    if errors:
        return jsonify({"errors": errors}), 400
    cur = mysql.connection.cursor()
    cur.execute(
        "INSERT INTO fruits (name, is_rotten, is_ripe, acquired_from, color, category_id) VALUES (%s,%s,%s,%s,%s,%s)",
        (
            payload.get("name"),
            int(bool(payload.get("is_rotten", 0))),
            int(bool(payload.get("is_ripe", 0))),
            payload.get("acquired_from"),
            payload.get("color"),
            payload.get("category_id"),
        )
    )
    mysql.connection.commit()
    new_id = cur.lastrowid
    cur.close()
    return jsonify({"msg": "created", "id": new_id}), 201


@app.route('/fruits/<int:item_id>', methods=['PUT'])
@jwt_required()
def update_fruit(item_id):
    payload = request.get_json() or {}
    if not payload:
        return jsonify({"msg": "No payload"}), 400
    errors = validate_fruit_payload(payload, partial=True)
    if errors:
        return jsonify({"errors": errors}), 400
    keys = []
    vals = []
    allowed = ["name","is_rotten","is_ripe","acquired_from","color","category_id"]
    for k in allowed:
        if k in payload:
            keys.append(f"{k}=%s")
            if k in ("is_rotten","is_ripe"):
                vals.append(int(bool(payload[k])))
            else:
                vals.append(payload[k])
    if not keys:
        return jsonify({"msg": "Nothing to update"}), 400
    vals.append(item_id)
    cur = mysql.connection.cursor()
    cur.execute(f"UPDATE fruits SET {', '.join(keys)} WHERE id=%s", tuple(vals))
    mysql.connection.commit()
    changed = cur.rowcount
    cur.close()
    if changed == 0:
        return jsonify({"msg":"Not found"}), 404
    return jsonify({"msg":"updated"}), 200

@app.route("/fruits/<int:item_id>", methods=["DELETE"])
@jwt_required()
def delete_fruit(item_id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM fruits WHERE id=%s", (item_id,))
    mysql.connection.commit()
    rc = cur.rowcount
    cur.close()
    if rc == 0:
        return jsonify({"msg": "Not found"}), 404
    return jsonify({"msg": "deleted"}), 200

if __name__ == '__main__':
    app.run(debug=True)
