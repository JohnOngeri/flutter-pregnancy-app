🎯 Mission
To leverage machine learning for accurately predicting birth weight based on maternal and prenatal health factors, improving early risk assessment for newborns.

📄 Brief Description
This project implements a machine learning model to predict birth weight using key maternal and prenatal parameters such as gestation period, parity, age, height, weight, and smoking status. The model is deployed via an API, allowing users to access predictions remotely.
📊 Source of Data
The dataset used for training and testing the model was obtained from Kaggle. It includes key maternal health indicators and birth outcomes, enabling the development of a predictive model for birth weight.

📌 Dataset & Analysis: https://www.kaggle.com/code/sahanasantosh/birthweight-prediction/notebook
## 📌 Features  
✅ Birth weight prediction using trained ML models  
✅ Public API endpoint for predictions  
✅ SWAGGER UI for API testing  
✅ Deployment-ready with clear setup instructions  
✅ YouTube demo of the implementation  

## 🚀 How to Use  

### **1️⃣ API Endpoint**  
The model is accessible via a publicly available API endpoint. This endpoint returns birth weight predictions based on input values.  

🔗 **API Endpoint:**'https://flutter-pregnancy-app-4.onrender.com 

You can test the API using **Swagger UI** at:  
🔗 **Swagger URL:**https://flutter-pregnancy-app-4.onrender.com/docs 

### **2️⃣ Running the API Locally**  
To run the API locally:  
1. Clone this repository  
2. Install dependencies:  
   ```bash
   pip install -r requirements.txt
Start the FastAPI server:
uvicorn api_task2:app --host 0.0.0.0 --port 8000
Open Swagger UI in your browser:
arduino

http://127.0.0.1:8000/docs
3️⃣ Demo Video
📺 Watch the YouTube Demo:(https://youtu.be/05JrfCqH4bE?si=Y22jacv5hoY9HXqW)

4️⃣ Deployment Notes
Ensure the API is hosted on a publicly routable URL (not localhost).
The API should handle incoming requests and return predictions reliably.
📌 Return to Main Repository → Back to Root README
📌 Explore the Flutter App → Pregnancy Tracker App
