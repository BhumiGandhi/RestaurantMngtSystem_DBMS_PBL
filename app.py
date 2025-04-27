from flask import Flask, request, jsonify, render_template, session, redirect, url_for
from flask_cors import CORS
from flask_mysqldb import MySQL
import os
import json
from werkzeug.security import generate_password_hash, check_password_hash
import datetime

app = Flask(__name__, static_folder='static', template_folder='.')
CORS(app)

# MySQL Configuration
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password'
app.config['MYSQL_DB'] = 'hotchix_db'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

# Session configuration
app.secret_key = 'hotchix_secret_key'

# Initialize MySQL
mysql = MySQL(app)

# Routes
@app.route('/')
def index():
    return render_template('index.html')

# Authentication routes
@app.route('/api/register', methods=['POST'])
def register():
    data = request.get_json()
    
    # Extract user data
    name = data.get('name')
    email = data.get('email')
    phone = data.get('phone')
    password = data.get('password')
    
    # Validate data
    if not name or not email or not phone or not password:
        return jsonify({'success': False, 'message': 'All fields are required'}), 400
    
    # Hash password
    hashed_password = generate_password_hash(password)
    
    # Check if user already exists
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM customer WHERE c_email = %s", [email])
    existing_user = cur.fetchone()
    
    if existing_user:
        cur.close()
        return jsonify({'success': False, 'message': 'Email already registered'}), 400
    
    # Insert new user
    try:
        cur.execute(
            "INSERT INTO customer (c_name, c_email, c_contact, c_password) VALUES (%s, %s, %s, %s)",
            (name, email, phone, hashed_password)
        )
        mysql.connection.commit()
        cur.close()
        
        return jsonify({'success': True, 'message': 'Registration successful'}), 201
    except Exception as e:
        cur.close()
        return jsonify({'success': False, 'message': str(e)}), 500

@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_json()
    
    # Extract login data
    email = data.get('email')
    password = data.get('password')
    
    # Validate data
    if not email or not password:
        return jsonify({'success': False, 'message': 'Email and password are required'}), 400
    
    # Check user credentials
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM customer WHERE c_email = %s", [email])
    user = cur.fetchone()
    cur.close()
    
    if not user or not check_password_hash(user['c_password'], password):
        return jsonify({'success': False, 'message': 'Invalid credentials'}), 401
    
    # Set session data
    session['logged_in'] = True
    session['user_id'] = user['c_id']
    session['user_name'] = user['c_name']
    session['user_email'] = user['c_email']
    
    return jsonify({
        'success': True,
        'message': 'Login successful',
        'user': {
            'id': user['c_id'],
            'name': user['c_name'],
            'email': user['c_email']
        }
    }), 200

@app.route('/api/logout', methods=['POST'])
def logout():
    session.clear()
    return jsonify({'success': True, 'message': 'Logout successful'}), 200

# Customer routes
@app.route('/api/customer/profile', methods=['GET'])
def get_customer_profile():
    if not session.get('logged_in'):
        return jsonify({'success': False, 'message': 'Unauthorized'}), 401
    
    user_id = session.get('user_id')
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT c_id, c_name, c_email, c_contact FROM customer WHERE c_id = %s", [user_id])
    user = cur.fetchone()
    cur.close()
    
    if not user:
        return jsonify({'success': False, 'message': 'User not found'}), 404
    
    return jsonify({
        'success': True,
        'user': user
    }), 200

@app.route('/api/customer/profile', methods=['PUT'])
def update_customer_profile():
    if not session.get('logged_in'):
        return jsonify({'success': False, 'message': 'Unauthorized'}), 401
    
    user_id = session.get('user_id')
    data = request.get_json()
    
    # Extract updated data
    name = data.get('name')
    phone = data.get('phone')
    
    # Validate data
    if not name or not phone:
        return jsonify({'success': False, 'message': 'Name and phone are required'}), 400
    
    # Update user profile
    try:
        cur = mysql.connection.cursor()
        cur.execute(
            "UPDATE customer SET c_name = %s, c_contact = %s WHERE c_id = %s",
            (name, phone, user_id)
        )
        mysql.connection.commit()
        cur.close()
        
        # Update session data
        session['user_name'] = name
        
        return jsonify({'success': True, 'message': 'Profile updated successfully'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

# Order routes
@app.route('/api/orders', methods=['POST'])
def create_order():
    if not session.get('logged_in'):
        return jsonify({'success': False, 'message': 'Unauthorized'}), 401
    
    user_id = session.get('user_id')
    data = request.get_json()
    
    # Extract order data
    items = data.get('items')
    total_amount = data.get('total_amount')
    
    # Validate data
    if not items or not total_amount:
        return jsonify({'success': False, 'message': 'Items and total amount are required'}), 400
    
    # Create order
    try:
        cur = mysql.connection.cursor()
        
        # Insert order
        cur.execute(
            "INSERT INTO `order` (customer_id, order_date_time, order_amount) VALUES (%s, %s, %s)",
            (user_id, datetime.datetime.now(), total_amount)
        )
        order_id = cur.lastrowid
        
        # Insert order items
        for item in items:
            cur.execute(
                "INSERT INTO order_items (order_id, item_name, item_price, quantity) VALUES (%s, %s, %s, %s)",
                (order_id, item['name'], item['price'], item['quantity'])
            )
        
        mysql.connection.commit()
        cur.close()
        
        return jsonify({
            'success': True,
            'message': 'Order placed successfully',
            'order_id': order_id
        }), 201
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

@app.route('/api/orders', methods=['GET'])
def get_customer_orders():
    if not session.get('logged_in'):
        return jsonify({'success': False, 'message': 'Unauthorized'}), 401
    
    user_id = session.get('user_id')
    
    cur = mysql.connection.cursor()
    cur.execute(
        "SELECT * FROM `order` WHERE customer_id = %s ORDER BY order_date_time DESC",
        [user_id]
    )
    orders = cur.fetchall()
    
    # Get items for each order
    for order in orders:
        cur.execute(
            "SELECT * FROM order_items WHERE order_id = %s",
            [order['order_id']]
        )
        order['items'] = cur.fetchall()
    
    cur.close()
    
    return jsonify({
        'success': True,
        'orders': orders
    }), 200

# Admin routes
@app.route('/api/admin/login', methods=['POST'])
def admin_login():
    data = request.get_json()
    
    # Extract login data
    email = data.get('email')
    password = data.get('password')
    
    # Validate data
    if not email or not password:
        return jsonify({'success': False, 'message': 'Email and password are required'}), 400
    
    # Check admin credentials
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM staff WHERE s_email = %s", [email])
    admin = cur.fetchone()
    cur.close()
    
    if not admin or not check_password_hash(admin['s_password'], password):
        return jsonify({'success': False, 'message': 'Invalid credentials'}), 401
    
    # Set session data
    session['admin_logged_in'] = True
    session['admin_id'] = admin['s_id']
    session['admin_name'] = admin['s_name']
    
    return jsonify({
        'success': True,
        'message': 'Admin login successful',
        'admin': {
            'id': admin['s_id'],
            'name': admin['s_name']
        }
    }), 200

@app.route('/api/admin/orders', methods=['GET'])
def get_all_orders():
    if not session.get('admin_logged_in'):
        return jsonify({'success': False, 'message': 'Unauthorized'}), 401
    
    cur = mysql.connection.cursor()
    cur.execute(
        """
        SELECT o.*, c.c_name, c.c_email, c.c_contact
        FROM `order` o
        JOIN customer c ON o.customer_id = c.c_id
        ORDER BY o.order_date_time DESC
        """
    )
    orders = cur.fetchall()
    
    # Get items for each order
    for order in orders:
        cur.execute(
            "SELECT * FROM order_items WHERE order_id = %s",
            [order['order_id']]
        )
        order['items'] = cur.fetchall()
    
    cur.close()
    
    return jsonify({
        'success': True,
        'orders': orders
    }), 200

@app.route('/api/admin/orders/<int:order_id>', methods=['PUT'])
def update_order_status(order_id):
    if not session.get('admin_logged_in'):
        return jsonify({'success': False, 'message': 'Unauthorized'}), 401
    
    data = request.get_json()
    status = data.get('status')
    
    # Validate data
    if not status:
        return jsonify({'success': False, 'message': 'Status is required'}), 400
    
    # Update order status
    try:
        cur = mysql.connection.cursor()
        cur.execute(
            "UPDATE `order` SET status = %s WHERE order_id = %s",
            (status, order_id)
        )
        mysql.connection.commit()
        cur.close()
        
        return jsonify({'success': True, 'message': 'Order status updated successfully'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

# Run the app
if __name__ == '__main__':
    app.run(debug=True)
