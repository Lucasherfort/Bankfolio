import 'package:flutter/material.dart';

class BankCard extends StatelessWidget {
  final String bankName;
  final List<Map<String, dynamic>> accounts;
  final VoidCallback onAddAccount;
  final VoidCallback onDelete;

  const BankCard({
    super.key,
    required this.bankName,
    required this.accounts,
    required this.onAddAccount,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom de la banque + icônes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(bankName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            ...accounts.map((acc) {
              double montant = (acc['amount'] as num).toDouble();
              double interest = (acc['interest'] as num).toDouble();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Type de compte à gauche
                    Text(
                      acc['type'],
                      style: const TextStyle(fontSize: 16),
                    ),

                    // Montant au centre
                    Text(
                      montant.toStringAsFixed(2) + " €",
                      style: const TextStyle(fontSize: 16),
                    ),

                    // Intérêt à droite avec couleur
                    Text(
                      (interest >= 0 ? "+" : "") + interest.toStringAsFixed(2) + " €",
                      style: TextStyle(
                        fontSize: 16,
                        color: interest >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 10),

            // Bouton pour ajouter un compte
            ElevatedButton.icon(
              onPressed: onAddAccount,
              icon: const Icon(Icons.add),
              label: const Text("Ajouter un compte"),
            ),
          ],
        ),
      ),
    );
  }
}