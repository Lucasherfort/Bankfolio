import 'package:flutter/material.dart';
import 'package:myapplication/pages/savings_account.dart';

class InvestmentsCard extends StatelessWidget {
  final List<SavingsAccount> accounts;
  final VoidCallback onTap;

  const InvestmentsCard({
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

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITRE + VALEUR À DROITE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mes Investissements",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Valeur affichée selon présence ou non de comptes
                  Text(
                    hasNoAccounts
                        ? "0,00 €"
                        : "${totalAmount.toStringAsFixed(2)} €",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: hasNoAccounts
                          ? Colors.black
                          : (totalInterest >= 0 ? Colors.green : Colors.red),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Texte sous la valeur si aucun compte
              if (hasNoAccounts)
                const Text(
                  "Cliquez pour ajouter un placement",
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}