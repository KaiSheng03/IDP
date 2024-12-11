from flask import Flask, request, jsonify
import mysql.connector
import tensorflow as tf
from PIL import Image
import numpy as np
import os
import threading

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads/'

# MySQL Database Configuration
db = mysql.connector.connect(
    host='localhost',
    user='root',
    password='159357',
    database='idp'
)
cursor = db.cursor(dictionary=True)

# TensorFlow Lite Model Loading
model_lock = threading.Lock()  # Lock for thread safety

# Load TensorFlow Lite model and interpreter
interpreter = tf.lite.Interpreter(model_path="model.tflite")
interpreter.allocate_tensors()

# Get input and output details for inference
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Helper function to preprocess the image
def preprocess_image(image):
    image = image.resize((224, 224))  # Resize to match model input
    image = np.array(image, dtype=np.float32) / 255.0  # Normalize to [0, 1]
    image = np.expand_dims(image, axis=0)  # Add batch dimension
    return image

# Endpoint to fetch data from MySQL
@app.route('/data', methods=['GET'])
def get_data():
    cursor.execute('SELECT * FROM user')
    results = cursor.fetchall()
    return jsonify(results)

# Endpoint to add a user
@app.route('/addUser', methods=['POST'])
def add_user():
    data = request.json
    query = "INSERT INTO user (name, password, email) VALUES (%s, %s, %s)"
    cursor.execute(query, (data['name'], data['password'], data['email']))
    db.commit()
    return jsonify({"message": "User added successfully", "userId": cursor.lastrowid})

# Endpoint for user login
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    query = "SELECT * FROM user WHERE name = %s AND password = %s"
    cursor.execute(query, (data['name'], data['password']))
    user = cursor.fetchone()
    if user:
        return jsonify({"message": "Login successful", "user": user})
    else:
        return jsonify({"message": "Invalid username or password"}), 401

# Endpoint to make predictions
@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    file = request.files['image']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        image = Image.open(file)
        processed_image = preprocess_image(image)

        with model_lock:  # Ensure thread-safe prediction
            interpreter.set_tensor(input_details[0]['index'], processed_image)
            interpreter.invoke()  # Run inference
            output_data = interpreter.get_tensor(output_details[0]['index'])

        result = output_data.tolist()  # Convert to a list for JSON serialization
        print(result)
        return jsonify({'prediction': result})

    except Exception as e:
        return jsonify({'error': f'Error processing image: {str(e)}'}), 500


@app.route('/get-patient', methods=['GET'])
def getPatient():
    doctor_id = request.args.get('doctor_id')  # Get doctor_id from query params
    if doctor_id is None:
        return jsonify({'message': 'Doctor ID is required'}), 400
    
    try:
        query = 'SELECT * FROM patient WHERE doctor = %s'
        cursor.execute(query, (doctor_id,))
        patients = cursor.fetchall()

        if not patients:
            return jsonify({'message': 'No patients found'}), 404
        
        for patient in patients:
            patient['ic'] = int(patient['ic'])
            patient['age'] = int(patient['age'])

        return jsonify(patients)

    except Exception as e:
        return jsonify({'message': str(e)}), 500

@app.route('/add-patient', methods=['POST'])
def addPatient():
    data = request.json
    name = data['name']
    patient_ic = data['ic']
    age = data['age']
    phone = data['phone']
    email = data['email']
    doctor = data['doctor']
    query = '''
        INSERT INTO patient (name, age, ic, email, phone_number, doctor)
        VALUES (%s, %s, %s, %s, %s, %s)
        '''
    cursor.execute(query, (name, age, patient_ic, email, phone, doctor))
    db.commit()
    return jsonify({'message': 'Patient added successfully'}), 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True, threaded=True)  # Enable threading
