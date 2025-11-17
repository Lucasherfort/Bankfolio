enum AssetType { Action, ETF }

class Asset {
  String name;
  AssetType type;
  double quantity;
  double pru; // Prix de revient unitaire

  Asset({
    required this.name,
    required this.type,
    required this.quantity,
    required this.pru,
  });

  double get totalValue => quantity * pru;
}