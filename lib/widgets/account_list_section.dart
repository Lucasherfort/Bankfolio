import 'package:flutter/material.dart';
import '../models/account.dart';

class AccountListSection extends StatelessWidget {
  final String title;
  final List<Account> accounts;
  final Function(Account) onEdit;
  final Function(Account) onDelete;

  const AccountListSection({
    super.key,
    required this.title,
    required this.accounts,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        ...accounts.map((account) => Card(
          color: Colors.white.withOpacity(0.9),
          margin: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => onEdit(account),
            onLongPress: () => onDelete(account),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Solde en bas à gauche
                      Text(
                        '${account.balance.toStringAsFixed(2)} €',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      // Intérêts à droite colorés
                      if (account.type == AccountType.Epargne)
                        Text(
                          'Intérêts : ${account.interests?.toStringAsFixed(2) ?? 0} €',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: (account.interests ?? 0) >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }
}