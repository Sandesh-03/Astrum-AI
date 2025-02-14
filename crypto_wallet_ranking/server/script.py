import pandas as pd
from flask import Flask, jsonify
from flask_cors import CORS
from sklearn.preprocessing import MinMaxScaler

app = Flask(__name__)
CORS(app)  # Enable CORS for API access from Flutter

# Load wallet data from CSV
file_path = "wallets_data.csv"
df = pd.read_csv(file_path)

# Ensure required columns exist
required_columns = ["Wallet Address", "ROI", "Trading Frequency", "Activity Level",
                    "Portfolio Volatility", "Sharpe Ratio", "Loss Ratio"]
for col in required_columns:
    if col not in df.columns:
        raise ValueError(f"Missing required column: {col}")

# Normalize data using MinMaxScaler
scaler = MinMaxScaler()
df[["ROI", "Trading Frequency", "Activity Level", "Portfolio Volatility", "Sharpe Ratio", "Loss Ratio"]] = scaler.fit_transform(
    df[["ROI", "Trading Frequency", "Activity Level", "Portfolio Volatility", "Sharpe Ratio", "Loss Ratio"]]
)

# Compute Rank Score (higher score = better ranking)
df["Rank Score"] = (df["ROI"] * 0.3 + df["Trading Frequency"] * 0.2 + 
                    df["Activity Level"] * 0.2 + df["Sharpe Ratio"] * 0.2 - 
                    df["Loss Ratio"] * 0.1 - df["Portfolio Volatility"] * 0.1)

# Sort and assign unique ranks (highest score = best rank)
df = df.sort_values(by="Rank Score", ascending=False).reset_index(drop=True)
df["Final Rank"] = df["Rank Score"].rank(method="first", ascending=False).astype(int)

# Save ranked data
df.to_csv("ranked_wallets.csv", index=False)

@app.route("/wallets", methods=["GET"])
def get_wallets():
    """Returns a list of ranked wallets."""
    return jsonify(df[["Wallet Address", "Final Rank", "Rank Score"]].to_dict(orient="records"))

@app.route("/wallet/<wallet_address>", methods=["GET"])
def get_wallet_details(wallet_address):
    """Returns details of a specific wallet."""
    wallet_data = df[df["Wallet Address"] == wallet_address]
    if wallet_data.empty:
        return jsonify({"error": "Wallet not found"}), 404
    return jsonify(wallet_data.to_dict(orient="records")[0])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
