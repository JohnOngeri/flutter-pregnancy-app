from fastapi import FastAPI
from pydantic import BaseModel, conint, confloat
import joblib
import numpy as np
from fastapi.middleware.cors import CORSMiddleware

# Load the trained model and scaler
model = joblib.load("best_model.pkl")
scaler = joblib.load("scaler.pkl")

# Define FastAPI app
app = FastAPI()

# Enable CORS (Cross-Origin Resource Sharing)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define request schema using Pydantic
class BirthweightInput(BaseModel):
    Gestation: conint(gt=200, lt=310)  # Gestation in days (reasonable range)
    parity: conint(ge=0, le=10)  # Parity (number of previous births)
    age: conint(gt=15, lt=50)  # Mother's age
    height: confloat(gt=120, lt=200)  # Mother's height in cm
    weight: confloat(gt=35, lt=150)  # Mother's pre-pregnancy weight in kg
    smoke: conint(ge=0, le=1)  # Smoking status (0 = No, 1 = Yes)


@app.get("/")
def read_root():
    return {"message": "Welcome to my API!"}

@app.post("/predict")
def predict_birthweight(input_data: BirthweightInput):
    try:
        # Prepare input
        input_array = np.array([[input_data.Gestation, input_data.parity, input_data.age,
                                  input_data.height, input_data.weight, input_data.smoke]])
        input_scaled = scaler.transform(input_array)
        
        # Predict birthweight
        predicted_weight = model.predict(input_scaled)[0]
        
        return {"predicted_birthweight": f"{predicted_weight:.2f} grams"}
    except Exception as e:
        print(f"Error: {e}")
        return {"error": "An error occurred while making a prediction."}

# Run server
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)



""""
This is a FastAPI application that predicts the birth weight of a baby based on several input parameters. The input parameters are defined using Pydantic's BaseModel and include:

Gestation (in days)
Smoking status (0 = No, 1 = Yes)
Mother's age
Mother's height (in cm)
Mother's pre-pregnancy weight (in kg)
Father's age
Father's height (in cm)
The application uses a pre-trained machine learning model best_model.pkl and a scaler ("scaler.pkl") to make predictions. The input data is scaled using the scaler and then passed to the model to predict the birth weight. The predicted weight is then returned as a JSON response.

The application also enables CORS (Cross-Origin Resource Sharing) to allow requests from any origin.

To run the application, you can use the uvicorn command, specifying the host and port as 0.0.0.0 and 8000, respectively.
"""