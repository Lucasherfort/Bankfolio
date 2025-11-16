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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  void addAccount() {
    final String name = nameController.text.trim();
    final double? amount = double.tryParse(amountController.text.trim());

    if (name.isEmpty || amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    widget.onAdd(SavingsAccount(name: name, amount: amount, interest: 0));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Épargne")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: widget.accounts.isEmpty
                  ? const Center(child: Text("Aucun compte enregistré"))
                  : ListView.separated(
                itemCount: widget.accounts.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final acc = widget.accounts[index];
                  return ListTile(
                    title: Text(acc.name),
                    trailing: Text("${acc.amount.toStringAsFixed(2)} €"),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Ajouter un compte",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nom du compte"),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Montant initial (€)"),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addAccount,
                child: const Text("Ajouter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
