import 'package:flutter/material.dart';

class AddAccountPage extends StatefulWidget {
  final String bankName;
  const AddAccountPage({super.key, required this.bankName});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  String _selectedType = 'Livret A';
  final Map<String, double> _plafonds = {'Livret A': 22950.0, 'LDDS': 12000.0};

  void _addAccount() {
    double? amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    double? interest = double.tryParse(_interestController.text.replaceAll(',', '.')) ?? 0.0;

    if (amount == null || amount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un montant valide")),
      );
      return;
    }

    // Vérification plafond
    if (amount > _plafonds[_selectedType]!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le $_selectedType ne peut pas dépasser ${_plafonds[_selectedType]!.toStringAsFixed(2)} €")),
      );
      return;
    }

    Navigator.pop(context, {
      'type': _selectedType,
      'amount': amount,
      'interest': interest, // directement en euros
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un compte à ${widget.bankName}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: "Type de compte"),
              items: ['Livret A', 'LDDS']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Montant",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _interestController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Intérêts",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _addAccount, child: const Text("Ajouter")),
          ],
        ),
      ),
    );
  }
}
