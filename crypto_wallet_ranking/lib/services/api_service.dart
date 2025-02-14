import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wallet.dart';

class ApiService {
  static const String baseUrl = "http://192.168.87.24:5000"; //replace

  static Future<List<Wallet>> fetchWallets() async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/wallets"))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Wallet.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load wallets: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching wallets: $e");
    }
  }

  static Future<Map<String, dynamic>> fetchWalletDetails(String address) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/wallet/$address"))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Wallet not found");
      }
    } catch (e) {
      throw Exception("Error fetching wallet details: $e");
    }
  }
}
