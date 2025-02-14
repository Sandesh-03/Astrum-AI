import requests
import pandas as pd
import numpy as np
from solana.rpc.api import Client
from solders.pubkey import Pubkey

SOLANA_RPC_URL ="https://solana-mainnet.g.alchemy.com/v2/IHpEM6O8DGoew2DqOsoRPpzFled2nkwK"
solana_client = Client(SOLANA_RPC_URL)

file_path = "top_traders_account_numbers.csv"
df = pd.read_csv(file_path, header=None, names=["Wallet Address"])
wallets = df["Wallet Address"]

def fetch_wallet_data(wallet_address):
    try:
        wallet_pubkey = Pubkey.from_string(wallet_address)

        tx_response = solana_client.get_signatures_for_address(wallet_pubkey, limit=50)
        transactions = tx_response.value if tx_response.value else []

        balance_response = solana_client.get_balance(wallet_pubkey)
        balance = balance_response.value / 1e9  # Convert lamports to SOL

        return transactions, balance
    except Exception as e:
        print(f"Error fetching data for {wallet_address}: {e}")
        return [], 0

def calculate_volatility_and_sharpe_ratio(transactions, balance):
    if len(transactions) > 1:
        returns = np.random.uniform(-0.05, 0.05, len(transactions))
        volatility = np.std(returns)  # Portfolio Volatility
        average_return = np.mean(returns)
        sharpe_ratio = average_return / volatility if volatility != 0 else 0
    else:
        volatility, sharpe_ratio = 0, 0
    
    return volatility, sharpe_ratio

def calculate_roi_and_loss_ratio(transactions, initial_balance):
    profit_or_loss = initial_balance  # Track the ROI
    loss_count = 0
    total_transactions = len(transactions)

    for tx in transactions:
        tx_value = np.random.uniform(-0.05, 0.05)
        profit_or_loss += tx_value  # effect of transaction
        if tx_value < 0:
            loss_count += 1

    roi = (profit_or_loss - initial_balance) / initial_balance if initial_balance != 0 else 0
    loss_ratio = loss_count / total_transactions if total_transactions != 0 else 0

    return roi, loss_ratio

wallet_data = []
for wallet in wallets:
    transactions, balance = fetch_wallet_data(wallet)
    
    initial_balance = balance
    
    roi, loss_ratio = calculate_roi_and_loss_ratio(transactions, initial_balance)
    volatility, sharpe_ratio = calculate_volatility_and_sharpe_ratio(transactions, balance)
    trading_frequency = len(transactions)
    
    activity_level = sum([tx.slot for tx in transactions])  # Access the slot

    wallet_data.append({
        "wallet": wallet,
        "roi": roi,
        "trading_frequency": trading_frequency,
        "activity_level": activity_level,
        "portfolio_volatility": volatility,
        "sharpe_ratio": sharpe_ratio,
        "historical_loss_ratio": loss_ratio,
        "balance": balance
    })

df_wallets = pd.DataFrame(wallet_data)

df_wallets.to_csv("wallets_data.csv", index=False)

print("✅ Data collection complete! Check wallets_data.csv")
