import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../services/api_service.dart';

class WalletProvider with ChangeNotifier {
  List<Wallet> _wallets = [];

  List<Wallet> get wallets => _wallets;

  Future<void> fetchWallets() async {
    try {
      _wallets = await ApiService.fetchWallets();
      notifyListeners();
    } catch (e) {
      print("Error: $e"); 
    }
  }
}
