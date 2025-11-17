import 'package:flutter/material.dart';
import '../models/account.dart';

class AddAccountDialog extends StatefulWidget {
  final Function(Account) onAdd;
  final List<Account> existingAccounts;
  final Account? account; // si présent, c'est une édition

  const AddAccountDialog({
    super.key,
    required this.onAdd,
    required this.existingAccounts,
    this.account,
  });

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  AccountType? selectedType;
  SavingsType? selectedSavingsType;
  TextEditingController balanceController = TextEditingController();
  TextEditingController interestsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Si édition, pré-remplir les champs
    if (widget.account != null) {
      selectedType = widget.account!.type;
      selectedSavingsType = widget.account!.savingsType;
      balanceController.text = widget.account!.balance.toStringAsFixed(2);
      interestsController.text = widget.account!.interests?.toStringAsFixed(2) ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(widget.account != null ? 'Modifier le compte' : 'Ajouter un compte'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Choix type : épargne ou investissement
          DropdownButtonFormField<AccountType>(
            value: selectedType,
            decoration: const InputDecoration(labelText: 'Type de compte'),
            items: [
              DropdownMenuItem(value: AccountType.Epargne, child: Text('Épargne')),
              DropdownMenuItem(value: AccountType.Investissement, child: Text('Investissement (PEA)')),
            ],
            onChanged: (value) {
              setState(() {
                selectedType = value;
                if (selectedType == AccountType.Investissement) {
                  selectedSavingsType = null;
                }
              });
            },
          ),
          const SizedBox(height: 8),

          // Si épargne, choisir Livret A ou LDDS
          if (selectedType == AccountType.Epargne)
            DropdownButtonFormField<SavingsType>(
              value: selectedSavingsType,
              decoration: const InputDecoration(labelText: 'Type d’épargne'),
              items: SavingsType.values.map((s) {
                bool disabled = widget.existingAccounts.any(
                      (a) => a.savingsType == s && a != widget.account,
                );
                return DropdownMenuItem(
                  value: s,
                  enabled: !disabled,
                  child: Text(s == SavingsType.LivretA ? 'Livret A' : 'LDDS'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSavingsType = value;
                });
              },
            ),
          const SizedBox(height: 8),

          // Montant solde
          TextField(
            controller: balanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Montant (€)'),
          ),

          // Intérêts uniquement pour épargne
          if (selectedType == AccountType.Epargne)
            TextField(
              controller: interestsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Intérêts (€)'),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler', style: TextStyle(color: Colors.teal)),
        ),
        ElevatedButton(
          onPressed: () {
            // Parsing nombres avec . ou ,
            double balance = double.tryParse(balanceController.text.replaceAll(',', '.')) ?? 0;
            double interests = double.tryParse(interestsController.text.replaceAll(',', '.')) ?? 0;

            // Vérifier plafonds épargne
            if (selectedType == AccountType.Epargne && selectedSavingsType != null) {
              double plafond = selectedSavingsType == SavingsType.LivretA ? 22950 : 12000;
              if (balance > plafond) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Le solde dépasse le plafond de ${plafond.toStringAsFixed(0)} €')),
                );
                return;
              }
            }

            // Créer ou modifier
            if (widget.account != null) {
              // Édition
              widget.account!
                ..balance = balance
                ..interests = interests
                ..type = selectedType!
                ..savingsType = selectedSavingsType;
              widget.onAdd(widget.account!);
            } else {
              // Création
              Account newAccount = Account(
                name: selectedType == AccountType.Epargne
                    ? (selectedSavingsType == SavingsType.LivretA ? 'Livret A' : 'LDDS')
                    : 'PEA',
                balance: balance,
                type: selectedType!,
                savingsType: selectedSavingsType,
                interests: selectedType == AccountType.Epargne ? interests : null,
              );
              widget.onAdd(newAccount);
            }

            Navigator.pop(context);
          },
          child: Text(widget.account != null ? 'Modifier' : 'Ajouter'),
        ),
      ],
    );
  }
}

