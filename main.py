from flask import Flask, request
from flask_mysqldb import MySQL
from flask import jsonify

app = Flask(__name__)
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'root'
app.config['MYSQL_DB'] = 'lagdb'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

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
