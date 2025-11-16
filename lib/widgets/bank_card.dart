import 'package:flutter/material.dart';

class BankCard extends StatelessWidget {
  final String bankName;
  final List<Map<String, dynamic>> accounts;
  final VoidCallback onDelete;
  final VoidCallback? onTap;
  final bool showAddButton;

  const BankCard({
    super.key,
    required this.bankName,
    required this.accounts,
    required this.onDelete,
    this.onTap,
    this.showAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calculer le total montant et intérêts si il y a des comptes
    double totalAmount = 0.0;
    double totalInterest = 0.0;
    if (accounts.isNotEmpty) {
      totalAmount = accounts.fold(
          0.0, (sum, acc) => sum + (acc['amount'] as double));
      totalInterest = accounts.fold(
          0.0, (sum, acc) => sum + (acc['interest'] as double));
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec nom de la banque + poubelle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(bankName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Ligne unique ou message si aucun compte
              if (accounts.isEmpty)
                const Text(
                  "Cliquez pour ajouter un compte",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${totalAmount.toStringAsFixed(2)} €",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "${totalInterest.toStringAsFixed(2)} €",
                      style: TextStyle(
                        fontSize: 16,
                        color: totalInterest >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),

              // Bouton ajouter un compte (optionnel)
              if (showAddButton)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.add),
                    label: const Text("Ajouter un compte"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}