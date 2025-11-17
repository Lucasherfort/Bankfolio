import 'package:flutter/material.dart';
import '../models/account.dart';

class AddAccountDialog extends StatefulWidget {
  final Function(Account) onAdd;
  final Account? account;
  final List<Account> existingAccounts;

  const AddAccountDialog({
    super.key,
    required this.onAdd,
    this.account,
    required this.existingAccounts,
  });

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  late String name;
  late String balance;
  late String interests;
  AccountType? selectedType;
  SavingsType? selectedSavingsType;

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      selectedType = widget.account!.type;
      name = widget.account!.name;
      balance = widget.account!.balance.toString();
      interests = widget.account!.interests?.toString() ?? '';
      selectedSavingsType = widget.account!.savingsType;
    } else {
      selectedType = null;
      name = '';
      balance = '';
      interests = '';
      selectedSavingsType = null;
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
              // Choix du type de compte
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
                  setStateDialog(() {
                    selectedType = value;
                    selectedSavingsType = null;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Si Épargne → choisir Livret A ou LDDS
              if (selectedType == AccountType.Epargne)
                DropdownButton<SavingsType>(
                  value: selectedSavingsType,
                  hint: const Text('Choisir le type d’épargne'),
                  isExpanded: true,
                  items: SavingsType.values.map((type) {
                    // Désactiver si déjà existant
                    bool disabled = widget.existingAccounts.any((a) =>
                    a.savingsType == type &&
                        a != widget.account); // ignore current account
                    return DropdownMenuItem(
                      value: disabled ? null : type,
                      enabled: !disabled,
                      child: Text(
                        type == SavingsType.LivretA ? 'Livret A' : 'LDDS',
                        style: disabled ? const TextStyle(color: Colors.grey) : null,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setStateDialog(() => selectedSavingsType = value);
                  },
                ),

              // Si Investissement → saisir le nom
              if (selectedType == AccountType.Investissement)
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
                if (selectedType == null) return;

                // Vérifications
                double parsedBalance = double.parse(balance.replaceAll(',', '.'));
                double? parsedInterests = selectedType == AccountType.Epargne
                    ? double.tryParse(interests.replaceAll(',', '.')) ?? 0
                    : null;

                // Plafonds
                if (selectedType == AccountType.Epargne) {
                  if (selectedSavingsType == SavingsType.LivretA &&
                      parsedBalance > 22950) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Le Livret A ne peut dépasser 22 950€')));
                    return;
                  }
                  if (selectedSavingsType == SavingsType.LDDS &&
                      parsedBalance > 12000) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Le LDDS ne peut dépasser 12 000€')));
                    return;
                  }
                }

                // Ajouter le compte
                widget.onAdd(Account(
                  name: selectedType == AccountType.Epargne
                      ? (selectedSavingsType == SavingsType.LivretA ? 'Livret A' : 'LDDS')
                      : name,
                  balance: parsedBalance,
                  type: selectedType!,
                  interests: parsedInterests,
                  savingsType: selectedSavingsType,
                ));
                Navigator.pop(context);
              },
              child: Text(widget.account != null ? 'Enregistrer' : 'Ajouter'),
            ),
          ],
        );
      },
    );
  }
}
