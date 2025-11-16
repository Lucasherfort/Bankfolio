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
              double total = montant + interest;

              print(total); // 19842.99

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  "${acc['type']} : ${total.toStringAsFixed(2)} €",
                  style: const TextStyle(fontSize: 16),
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