import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import 'wallet_detail_screen.dart';

class WalletListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wallet Rankings")),
      body: FutureBuilder(
        future:
            Provider.of<WalletProvider>(context, listen: false).fetchWallets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Consumer<WalletProvider>(
            builder: (context, provider, _) {
              if (provider.wallets.isEmpty) {
                return Center(child: Text("No wallets found."));
              }
              return ListView.builder(
                itemCount: provider.wallets.length,
                itemBuilder: (context, index) {
                  final wallet = provider.wallets[index];
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(wallet.address,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text("Rank: ${wallet.finalRank}"),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WalletDetailScreen(wallet.address),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
