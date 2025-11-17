enum AccountType { Epargne, Investissement }

enum SavingsType { LivretA, LDDS }

class Account {
  String name; // pour Investissements
  double balance;
  AccountType type;

  // Pour l'épargne
  double? interests;
  SavingsType? savingsType;

  Account({
    required this.name,
    required this.balance,
    required this.type,
    this.interests,
    this.savingsType,
  });
}
