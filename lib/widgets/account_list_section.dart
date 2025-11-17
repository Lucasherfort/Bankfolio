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
          child: ListTile(
            title: Text(account.name),
            subtitle: account.type == AccountType.Epargne
                ? Text('Intérêts : ${account.interests?.toStringAsFixed(2) ?? 0} €')
                : null,
            trailing: Text('${account.balance.toStringAsFixed(2)} €'),
            onTap: () => onEdit(account),
            onLongPress: () => onDelete(account),
          ),
        )),
      ],
    );
  }
}