# Final Project for CS Elective 1

A simple **Flask REST API** providing CRUD operations for Fruits and Categories, with **JWT Authentication** and **MySQL** integration.

---

## 📌 Project Overview

This project demonstrates:

* RESTful CRUD endpoints (GET, POST, PUT, DELETE)
* MySQL database integration
* JSON & XML output support
* JWT authentication for protected routes
* Search and filtering with `q` query parameter

---

## 🚀 Features

* **JWT login** using a demo user
* **Create, read, update, delete** fruits
* XML or JSON response format using `?format=xml`
* Search fruits by name or source using `?q=`

---

## 🛠 Installation

### **1. Clone the repository**

```bash
git clone https://github.com/ygglue/REST_Flask.git
cd REST_Flask
```

### **2. Create a virtual environment**

```bash
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
```

### **3. Install dependencies**

```bash
pip install -r requirements.txt
```

### **4. Configure MySQL**

Import `dump.sql` via a chosen MySQL connection:

```bash
1. In Navigator, click "Administration" tab
2. Click "Data Import/Restore"
3. Toggle "Import from Self-Contained File"
4. Navigate to dump.sql
5. Click "Start Import"
```

Create your `.env` file at `REST_Flask\.env`:
```bash
MYSQL_HOST=localhost #or 127.0.0.1 for TCP/IP connections
MYSQL_USER=root #your mysql username
MYSQL_PASSWORD=root #your mysql password
MYSQL_DB=fruitdb #db name of imported dump.sql
JWT_SECRET_KEY=fruitsapi
```

### **5. Run the server**

```bash
python main.py
```

Server runs at: `http://localhost:5000/`

---

## 🔐 Authentication

This API uses **JWT access tokens**.
A demo user is baked in:

```
username: admin
password: admin
```

### **Login**

```bash
POST /login
```

**Response:**

```json
{ "access_token": "JWT_STRING" }
```

Use the token:

```
Authorization: Bearer <token>
```

---

## 🍎 Fruits API

### **GET /fruits**

List all fruits.

```bash
curl http://localhost:5000/fruits
```

Search:

```
GET /fruits?q=apple
```

XML:

```
GET /fruits?format=xml
```

---

### **GET /fruits/<id>**

Fetch a single fruit.

```
curl http://localhost:5000/fruits/1
```

---

### **POST /fruits** *(Requires JWT)*

Create a fruit.

```bash
curl -X POST http://localhost:5000/fruits \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"name": "GumGum", "category_id": 1}'
```
Note: `name` and `category_id` are required when adding a fruit.

---

### **PUT /fruits/<id>** *(Requires JWT)*

Update a fruit.

```bash
curl -X PUT http://localhost:5000/fruits/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"color": "yellow"}'
```

---

### **DELETE /fruits/<id>** *(Requires JWT)*

```bash
curl -X DELETE http://localhost:5000/fruits/1 \
  -H "Authorization: Bearer <token>"
```

---

## 🧪 Testing With curl
Below are expanded real‑world test scenarios, including success cases, failures, bad input, expired tokens, and edge cases.

### **2. Login – Valid Credentials**
```bash
curl -X POST http://localhost:5000/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin", "password":"admin"}'
```

### **3. Login – Invalid Credentials**
```bash
curl -X POST http://localhost:5000/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin", "password":"wrong"}'
```
Expected: `401 Invalid credentials`

### **4. Access Protected Route Without Token**
```bash
curl http://localhost:5000/fruits -H "Authorization: Bearer"
```
Expected: Missing token error.

### **5. Access Protected Route With Invalid Token**
```bash
curl http://localhost:5000/fruits \
  -H "Authorization: Bearer abc.def.ghi"
```
Expected: Signature verification failure.

### **6. Access With Expired Token**
(Use a token past its expiration.)
```bash
curl http://localhost:5000/fruits \
  -H "Authorization: Bearer <expired_token>"
```
Expected: `{"msg": "Token has expired"}`

### **8. Create Fruit – Missing Required Fields**
```bash
curl -X POST http://localhost:5000/fruits \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"is_ripe":1}'
```
Expected: Validation error.

### **9. Fetch Fruit That Exists**
```bash
curl http://localhost:5000/fruits/1
```

### **10. Fetch Fruit That Does NOT Exist**
```bash
curl http://localhost:5000/fruits/99999
```
Expected: `404 Not Found`

### **11. Update Fruit – Partial Update**
```bash
curl -X PUT http://localhost:5000/fruits/1 \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"color":"yellow"}'
```

### **12. Update Fruit – Invalid Data Type**
```bash
curl -X PUT http://localhost:5000/fruits/1 \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"is_ripe":"not_bool"}'
```
Expected: Validation or type error.

### **13. Delete Fruit – Success**
```bash
curl -X DELETE http://localhost:5000/fruits/1 \
  -H "Authorization: Bearer <token>"
```

### **14. Delete Fruit – Already Deleted**
```bash
curl -X DELETE http://localhost:5000/fruits/1 \
  -H "Authorization: Bearer <token>"
```
Expected: `404 Not Found`

### **15. Search Fruits**
```bash
curl "http://localhost:5000/fruits?q=apple"
```
Search is available for `name` and `acquired_from`.

### **16. XML Response Format**
```bash
curl "http://localhost:5000/fruits?format=xml"
```

---

## 📎 Additional Notes

* XML output uses **dicttoxml**
* JWT errors are automatically handled by Flask-JWT-Extended
* Optional `@jwt_required(optional=True)` allows anonymous reads

---

## 👤 Author

Eliyahu Lagumbay (`ygglue`) — 2025
