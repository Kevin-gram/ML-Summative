from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
from fastapi.middleware.cors import CORSMiddleware

# Load the trained model
model = joblib.load("dementia.joblib")

# Mapping dictionaries
gender_mapping = {"Female": 0, "Male": 1}
married_mapping = {"No": 0, "Yes": 1}
education_mapping = {"Graduate": 0, "Not Graduate": 1}
self_employed_mapping = {"No": 0, "Yes": 1}
property_area_mapping = {"Rural": 0, "Semiurban": 1, "Urban": 2}
loan_status_mapping = {"N": 0, "Y": 1}
dependents_mapping = {"0": 0, "1": 1, "2": 2, "3+": 3}


class InputData(BaseModel):
    Loan_ID: str
    Gender: str
    Married: str
    Dependents: str
    Education: str
    Self_Employed: str
    ApplicantIncome: float
    CoapplicantIncome: float
    LoanAmount: float
    Loan_Amount_Term: float
    Credit_History: float
    Property_Area: str
    Loan_Status: str


# Initialize FastAPI
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def read_root():
    return {"message": "Welcome to the Dementia Prediction API"}


def convertRequestToModelValue(data: dict):
    # Convert the input dictionary to a list of model input values in the correct order
    return [
        gender_mapping[data["Gender"]],
        married_mapping[data["Married"]],
        dependents_mapping[data["Dependents"]],
        education_mapping[data["Education"]],
        self_employed_mapping[data["Self_Employed"]],
        data["ApplicantIncome"],
        data["CoapplicantIncome"],
        data["LoanAmount"],
        data["Loan_Amount_Term"],
        data["Credit_History"],
        property_area_mapping[data["Property_Area"]],
    ]


@app.post("/predict")
def predict(data: InputData):
    # Convert input data to the required format for the model
    input_data = [convertRequestToModelValue(data.dict())]

    # Make prediction
    prediction = model.predict(input_data)

    # Return the prediction as a response
    return {"prediction": round(prediction[0], 0)}
