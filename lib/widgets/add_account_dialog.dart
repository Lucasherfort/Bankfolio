import 'package:flutter/material.dart';
import '../models/account.dart';

class AddAccountDialog extends StatefulWidget {
  final Function(Account) onAdd;
  final Account? account;

  const AddAccountDialog({super.key, required this.onAdd, this.account});

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  late String name;
  late String balance;
  late String interests;
  AccountType? selectedType;

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      name = widget.account!.name;
      balance = widget.account!.balance.toString();
      interests = widget.account!.interests?.toString() ?? '';
      selectedType = widget.account!.type;
    } else {
      name = '';
      balance = '';
      interests = '';
      selectedType = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateDialog) {
        return AlertDialog(
          title: Text(widget.account != null ? 'Modifier le compte' : 'Ajouter un compte'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<AccountType>(
                value: selectedType,
                hint: const Text('Type de compte'),
                isExpanded: true,
                items: AccountType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type == AccountType.Epargne ? 'Épargne' : 'Investissement'),
                  );
                }).toList(),
                onChanged: (value) {
                  setStateDialog(() => selectedType = value);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Nom du compte'),
                controller: TextEditingController(text: name),
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Solde'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: TextEditingController(text: balance),
                onChanged: (value) => balance = value,
              ),
              if (selectedType == AccountType.Epargne)
                TextField(
                  decoration: const InputDecoration(labelText: 'Intérêts en cours'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController(text: interests),
                  onChanged: (value) => interests = value,
                ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && balance.isNotEmpty && selectedType != null) {
                  // Remplacement des virgules par des points
                  double parsedBalance = double.parse(balance.replaceAll(',', '.'));
                  double? parsedInterests = selectedType == AccountType.Epargne
                      ? double.tryParse(interests.replaceAll(',', '.')) ?? 0
                      : null;

                  widget.onAdd(Account(
                    name: name,
                    balance: parsedBalance,
                    type: selectedType!,
                    interests: parsedInterests,
                  ));
                  Navigator.pop(context);
                }
              },
              child: Text(widget.account != null ? 'Enregistrer' : 'Ajouter'),
            ),
          ],
        );
      },
    );
  }
}
