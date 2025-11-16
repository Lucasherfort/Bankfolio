import 'package:flutter/material.dart';
import 'savings_account.dart';

class SavingsInfoPage extends StatefulWidget {
  final List<SavingsAccount> accounts;
  final Function(SavingsAccount) onAdd;

  const SavingsInfoPage({
    super.key,
    required this.accounts,
    required this.onAdd,
  });

  @override
  State<SavingsInfoPage> createState() => _SavingsInfoPageState();
}

class _SavingsInfoPageState extends State<SavingsInfoPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  String _selectedType = 'Livret A';

  void _openAddDialog() {
    amountController.clear();
    interestController.clear();
    _selectedType = 'Livret A';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un compte épargne"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: "Type de compte"),
                items: ['Livret A', 'LDDS']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "Montant (€)"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: interestController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration:
                const InputDecoration(labelText: "Intérêt acquis (€)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: _addAccount,
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  void _addAccount() {
    final double? amount =
    double.tryParse(amountController.text.replaceAll(',', '.'));
    final double? interest =
    double.tryParse(interestController.text.replaceAll(',', '.'));

    if (amount == null || interest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer des valeurs valides.")),
      );
      return;
    }

    // Optionnel : Vérifier les plafonds
    final Map<String, double> plafonds = {'Livret A': 22950, 'LDDS': 12000};
    if (amount > plafonds[_selectedType]!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "$_selectedType ne peut pas dépasser ${plafonds[_selectedType]!.toStringAsFixed(2)} €")),
      );
      return;
    }

    widget.onAdd(SavingsAccount(
      name: _selectedType,
      amount: amount,
      interest: interest,
    ));

    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Épargne")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openAddDialog,
                child: const Text("Ajouter un compte épargne"),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: widget.accounts.isEmpty
                ? const Center(child: Text("Aucun compte d'épargne enregistré"))
                : ListView.separated(
              itemCount: widget.accounts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final acc = widget.accounts[index];
                return ListTile(
                  title: Text(acc.name),
                  trailing: Text(
                      "${acc.amount.toStringAsFixed(2)} € / +${acc.interest.toStringAsFixed(2)} €"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
