class SavingsAccount {
  String name;
  double amount;
  double interest;

  SavingsAccount({
    required this.name,
    required this.amount,
    required this.interest,
  });

  factory SavingsAccount.fromJson(Map<String, dynamic> json) {
    return SavingsAccount(
      name: json["name"] as String,
      amount: json["amount"] as double,
      interest: json["interest"] as double,
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
    "interest": interest,
  };
}
