class Account {
  final String name;
  final double balance;

  Account({required this.name, required this.balance});
}

// Exemple de données de test
final List<Account> demoAccounts = [
  Account(name: 'PEA', balance: 12000.0),
  Account(name: 'Livret A', balance: 5000.0),
  Account(name: 'Crypto', balance: 2000.0),
];
