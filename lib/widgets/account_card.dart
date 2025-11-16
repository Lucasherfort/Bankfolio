import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final Map<String, dynamic> account;

  const AccountCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    double montant = (account['amount'] as num).toDouble();
    double interest = (account['interest'] as num).toDouble();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(account['type'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(montant.toStringAsFixed(2) + " €", style: const TextStyle(fontSize: 16)),
            Text(
              (interest >= 0 ? "+" : "") + interest.toStringAsFixed(2) + " €",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: interest >= 0 ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}