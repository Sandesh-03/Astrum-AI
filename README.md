# **Crypto Wallet Ranking App** 🚀  

This project is a **Flutter + Flask** application that ranks cryptocurrency wallets based on their **historical performance and activity**. It collects wallet data, applies **machine learning models** for ranking, and provides an interactive mobile UI for users to track top-performing wallets.

---

## **📌 Features**  
✅ Collects **Solana wallet transaction history** & portfolio details  
✅ Uses **Machine Learning (Random Forest/XGBoost)** to rank wallets  
✅ **REST API (Flask)** to fetch ranked wallets & wallet details  
✅ **Flutter app** to display ranked wallets with detailed insights  
✅ **Copy wallet data** via a floating action button (FAB)  

---

## **🛠 Tech Stack**  
- **Backend:** Python (Flask, Pandas, Scikit-Learn)  
- **Frontend:** Flutter (Provider, HTTP, Material UI)  
- **Database:** CSV file (or can be extended to Firebase/PostgreSQL)  
- **ML Model:** Random Forest Regressor (for ranking wallets)  

---

## **📝 Approach**  
### **1️⃣ Data Collection**  
- Wallet data is stored in `wallets_data.csv`.  
- Data includes **ROI, Trading Frequency, Activity Level, Portfolio Volatility, Sharpe Ratio, and Loss Ratio**.  
- Flask API processes and serves ranked wallet data.  

### **2️⃣ Machine Learning for Ranking**  
- **Feature Normalization** using `MinMaxScaler`.  
- **Ranking Formula**:  
  ```python
  Rank Score = (ROI * 0.3) + (Trading Frequency * 0.2) + 
               (Activity Level * 0.2) + (Sharpe Ratio * 0.2) - 
               (Loss Ratio * 0.1) - (Portfolio Volatility * 0.1)```
- **Final Rank Calculation ensures unique ranks using:**:  
  ```python
  df["Final Rank"] = df["Rank Score"].rank(method="first", ascending=False).astype(int)


### **3️⃣ API Implementation (Flask)**  

| Endpoint                | Method | Description                       |
|-------------------------|--------|-----------------------------------|
| `/wallets`             | `GET`  | Returns a list of ranked wallets |
| `/wallet/<wallet_address>` | `GET`  | Returns wallet details           |


### **4️⃣ Flutter App Implementation**
- **Wallet List Screen:** Displays ranked wallets with scores  
- **Wallet Details Screen:** Shows wallet info with **Copy button (FAB)**  

---

## **🚀 Setup Instructions**

### **1️⃣ Backend (Flask) Setup**
#### **Install dependencies:**
```sh
pip install flask flask-cors pandas scikit-learn
```

#### **Run Flask API:**
```sh
python server.py
```

#### **API will be available at http://[your-ip]:5000. **



### **2️⃣ Flutter App Setup**
#### **Install Flutter: [Flutter Installation Guide](https://docs.flutter.dev/get-started/install/)**

#### **Install dependencies:**
```sh
flutter pub get
```
#### **Run App**
```sh
flutter run
```
#### ** add `-d chrome` or `-d edge` to run it on chrome or edge**

---
## **🕒 Time Spent & Challenges**

### **⏳ Time Spent**
- **Backend (Flask & ML Model)** → ~6 hours  
- **Flutter App (UI & API Integration)** → ~5 hours  
- **Testing & Debugging** → ~2 hours  

### **⚠️ Challenges & Optimizations**
🚧 **Handling Duplicate Ranks:** Used `rank(method="first")` to ensure **unique rankings**.  
🚧 **Flutter HTTP Requests Timing Out:** Fixed using **timeouts & error handling** in API calls.  
🚧 **UI Optimization:** Added **Loading Indicators** & **Snackbar for Copy Notification**.  

