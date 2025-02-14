import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class WalletDetailScreen extends StatefulWidget {
  final String address;
  const WalletDetailScreen(this.address, {super.key});

  @override
  State <WalletDetailScreen> createState() => _WalletDetailScreenState();
}

class _WalletDetailScreenState extends State<WalletDetailScreen> {
  late Future<Map<String, dynamic>> _walletDetails;

  @override
  void initState() {
    super.initState();
    _walletDetails = ApiService.fetchWalletDetails(widget.address);
  }

  void _copyToClipboard(Map<String, dynamic> data) {
    String formattedData = data.entries.map((e) => "${e.key}: ${e.value}").join("\n");
    Clipboard.setData(ClipboardData(text: formattedData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Wallet details copied to clipboard!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wallet Details")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _walletDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Error loading details"));
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: data.entries.map((e) => ListTile(title: Text("${e.key}: ${e.value}"))).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = await _walletDetails; 
          _copyToClipboard(data);
        },
        tooltip: "Copy Wallet Details",
        child: const Icon(Icons.copy),
      ),
    );
  }
}
