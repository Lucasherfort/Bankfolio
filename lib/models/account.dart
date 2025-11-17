enum AccountType { Epargne, Investissement }

class Account {
  String name;
  double balance;
  AccountType type;

  // Pour l'épargne simple (Livret A, LDDS)
  double? interests;

  // Pour les investissements, on pourra ajouter une liste d'actifs plus tard
  // List<Investment>? investments;

  Account({
    required this.name,
    required this.balance,
    required this.type,
    this.interests,
  });
}
