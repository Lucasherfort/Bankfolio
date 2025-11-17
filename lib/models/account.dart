import 'asset.dart';

enum AccountType { Epargne, Investissement, PEA }

enum SavingsType { LivretA, LDDS }

class Account {
  String name;
  double balance;
  AccountType type;

  // Pour l'épargne
  double? interests;
  SavingsType? savingsType;

  // Pour le PEA : liste des actifs
  List<Asset>? assets;

  Account({
    required this.name,
    required this.balance,
    required this.type,
    this.interests,
    this.savingsType,
    this.assets,
  });
}
