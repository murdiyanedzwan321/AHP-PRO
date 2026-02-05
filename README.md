# Agro-AHP Pro
**Microservices-Based Maintenance Decision System**

Created by: Murdiyan Edzwan Nazib
Case Study: Pabrik Kopi Roastery

## Project Overview
Agro-AHP Pro is a decision support system built with a Python (Flask) backend and a Flutter frontend. It uses the Analytic Hierarchy Process (AHP) to prioritize machine maintenance tasks based on technical and economic criteria.

## Repository Structure
- `/backend`: Python Flask code & Jupyter Notebook.
- `/frontend`: Flutter Mobile App source code.

## Getting Started

### 1. Backend Setup
The backend performs the heavy lifting of AHP Matrix calculations.

**Option A: Google Colab (Recommended for TOR)**
1. Open `/backend/Agro_AHP_Engine.ipynb` in Google Colab.
2. Run all cells.
3. Copy the generated **Ngrok URL** (e.g., `https://abcd.ngrok-free.app`).

**Option B: Localhost**
1. Install dependencies: `pip install -r backend/requirements.txt`
2. Run server: `python backend/app.py`
3. Server runs at `http://127.0.0.1:5000`

### 2. Configuration Bridge (Gist)
1. Create a public GitHub Gist named `config.json`.
2. Content: `{"base_url": "YOUR_NGROK_URL_HERE"}`
3. Get the **Raw URL** of the Gist.

### 3. Frontend Setup (Flutter)
1. Go to `frontend/lib/services/ahp_service.dart`.
2. Update `_configGistUrl` with your **Raw Gist URL**.
   - *Note: For local testing, the app is set to fallback to localhost:5000 automatically.*
3. Run the app:
   ```bash
   cd frontend
   flutter run
   ```

## Case Study Data (Pabrik Kopi Roastery)
**Criteria:**
1. Kestabilan Suhu Sangrai
2. Konsumsi Gas
3. Presisi Grinding

**Alternatives:**
- Mesin Roasting A (German)
- Mesin Roasting B (China)
- Mesin Roasting C (Lokal)
- Mesin Roasting D (Second)

## Deliverables Checklist
- [x] Backend API (Python/Flask)
- [x] Frontend UI (Flutter)
- [x] AHP Logic (Eigenvector & CR)
- [x] Case Study Implementation

## License
Student Project - EAS
