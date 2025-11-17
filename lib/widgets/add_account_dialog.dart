import 'package:flutter/material.dart';
import '../models/account.dart';
import '../models/asset.dart';

class AddAccountDialog extends StatefulWidget {
  final Function(Account) onAdd;
  final List<Account> existingAccounts;

  const AddAccountDialog({
    super.key,
    required this.onAdd,
    required this.existingAccounts,
  });

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  AccountType? selectedType;
  SavingsType? selectedSavingsType;
  String balance = '';
  String interests = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un compte'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Choix type général
            DropdownButton<AccountType>(
              value: selectedType,
              hint: const Text('Type de compte'),
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: AccountType.Epargne,
                  child: Text('Épargne'),
                ),
                DropdownMenuItem(
                  value: AccountType.Investissement,
                  child: Text('Investissement (PEA)'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                  selectedSavingsType = null;
                  balance = '';
                  interests = '';
                });
              },
            ),

            const SizedBox(height: 10),

            // Si Épargne → Livret A ou LDDS
            if (selectedType == AccountType.Epargne)
              DropdownButton<SavingsType>(
                value: selectedSavingsType,
                hint: const Text('Type d’épargne'),
                isExpanded: true,
                items: SavingsType.values.map((type) {
                  bool disabled = widget.existingAccounts.any((a) => a.savingsType == type);
                  return DropdownMenuItem(
                    value: disabled ? null : type,
                    enabled: !disabled,
                    child: Text(
                      type == SavingsType.LivretA ? 'Livret A' : 'LDDS',
                      style: disabled ? const TextStyle(color: Colors.grey) : null,
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedSavingsType = value),
              ),

            // Solde pour épargne
            if (selectedType == AccountType.Epargne)
              TextField(
                decoration: const InputDecoration(labelText: 'Solde'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => balance = value,
              ),

            // Intérêts pour épargne
            if (selectedType == AccountType.Epargne)
              TextField(
                decoration: const InputDecoration(labelText: 'Intérêts'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => interests = value,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler')),
        ElevatedButton(
          onPressed: () {
            if (selectedType == null) return;

            if (selectedType == AccountType.Epargne) {
              if (selectedSavingsType == null) return;

              double parsedBalance = double.tryParse(balance.replaceAll(',', '.')) ?? 0;
              double parsedInterests = double.tryParse(interests.replaceAll(',', '.')) ?? 0;

              // Plafonds
              if (selectedSavingsType == SavingsType.LivretA && parsedBalance > 22950) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Le Livret A ne peut dépasser 22 950€')));
                return;
              }
              if (selectedSavingsType == SavingsType.LDDS && parsedBalance > 12000) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Le LDDS ne peut dépasser 12 000€')));
                return;
              }

              widget.onAdd(Account(
                name: selectedSavingsType == SavingsType.LivretA ? 'Livret A' : 'LDDS',
                balance: parsedBalance,
                type: AccountType.Epargne,
                interests: parsedInterests,
                savingsType: selectedSavingsType,
              ));
            } else if (selectedType == AccountType.Investissement) {
              // Création PEA simple
              widget.onAdd(Account(
                name: 'PEA',
                balance: 0,
                type: AccountType.Investissement,
                assets: [],
              ));
            }

            Navigator.pop(context);
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
