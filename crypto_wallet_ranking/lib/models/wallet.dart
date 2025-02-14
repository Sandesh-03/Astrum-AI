class Wallet {
  final String address;
  final double rankScore;
  final int finalRank; 

  Wallet({required this.address, required this.rankScore, required this.finalRank});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      address: json["Wallet Address"],
      rankScore: json["Rank Score"].toDouble(),
      finalRank: json["Final Rank"].toInt(), 
    );
  }
}
