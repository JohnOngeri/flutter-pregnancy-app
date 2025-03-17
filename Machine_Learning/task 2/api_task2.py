from fastapi import FastAPI
from pydantic import BaseModel, conint, confloat
import joblib
import numpy as np
from fastapi.middleware.cors import CORSMiddleware

import pickle

# Load the model using joblib
model = joblib.load("best_model.pkl")
print("Model loaded successfully!")

# Initialize FastAPI app
app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define Pydantic model for input validation
class BirthweightInput(BaseModel):
    gestation: conint(gt=200, lt=310)  # Gestation days
    parity: conint(ge=0, le=10)  # Previous births
    age: conint(gt=15, lt=50)  # Mother's age
    height: confloat(gt=120, lt=200)  # Height in cm
    weight: confloat(gt=35, lt=150)  # Weight in kg
    smoke: conint(ge=0, le=1)  # Smoking status (0=No, 1=Yes)

@app.get("/")
def read_root():
    return {"message": "Welcome to my API!"}

@app.post("/predict")
def predict_birthweight(input_data: BirthweightInput):
    # Prepare input array
    input_array = np.array([[input_data.gestation, input_data.parity, input_data.age,
                              input_data.height, input_data.weight, input_data.smoke]])
    
    # Scale input data
    input_scaled = scaler.transform(input_array)
    
    # Make prediction
    predicted_weight = model.predict(input_scaled)[0]
    
    # Ensure reasonable prediction range
    predicted_weight = max(2500, min(predicted_weight, 4500))
    
    return {"predicted_birthweight": f"{predicted_weight:.2f} grams"}

# Run API
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)