import 'package:flutter/material.dart';
import '../pages/savings_account.dart';

class SavingsCard extends StatelessWidget {
  final List<SavingsAccount> accounts;
  final VoidCallback onTap;

  const SavingsCard({
    super.key,
    required this.accounts,
    required this.onTap,
  });

  double get totalAmount =>
      accounts.fold(0.0, (sum, a) => sum + a.amount);

  double get totalInterest =>
      accounts.fold(0.0, (sum, a) => sum + a.interest);

  @override
  Widget build(BuildContext context) {
    bool hasNoAccounts = accounts.isEmpty;

    double total = totalAmount + totalInterest;

    Color interestColor =
    total >= 0 ? Colors.green : Colors.red;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---- Ligne titre + montant ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mon Épargne",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  // Si vide → afficher 0,00€ en noir
                  // Si non vide → total en vert ou rouge
                  Text(
                    "${total.toStringAsFixed(2)} €",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: hasNoAccounts ? Colors.black : interestColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ---- Texte sous la ligne si aucun compte ----
              if (hasNoAccounts)
                const Text(
                  "Cliquez pour ajouter un compte",
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
