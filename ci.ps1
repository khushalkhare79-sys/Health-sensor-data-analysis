Write-Host "Step 1: Installing dependencies..."

python -m pip install --upgrade pip
pip install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    Write-Host "Dependency install failed"
    exit 1
}

Write-Host "Step 2: Lint check..."

pip install ruff
ruff check .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Lint failed"
    exit 1
}

Write-Host "Step 3: Testing model loading..."

python -c "
import joblib
model = joblib.load('backend/model.pkl')
scaler = joblib.load('backend/scaler.pkl')
print('Model loaded successfully')
"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Model loading failed"
    exit 1
}

Write-Host "Step 4: Running inference test..."

python -c "
import numpy as np
import joblib

model = joblib.load('backend/model.pkl')
scaler = joblib.load('backend/scaler.pkl')

sample = np.array([[72,120,80,16,98,36.5]])
scaled = scaler.transform(sample)

pred = model.predict(scaled)

print('Prediction:', pred)
"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Inference test failed"
    exit 1
}

Write-Host "All checks passed successfully!"