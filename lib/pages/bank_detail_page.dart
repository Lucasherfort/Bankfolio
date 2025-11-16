import 'package:flutter/material.dart';
import '../widgets/account_card.dart';
import 'add_account_page.dart';

class BankDetailPage extends StatefulWidget {
  final String bankName;
  final List<Map<String, dynamic>> accounts;

  const BankDetailPage({super.key, required this.bankName, required this.accounts});

  @override
  State<BankDetailPage> createState() => _BankDetailPageState();
}

class _BankDetailPageState extends State<BankDetailPage> {
  late List<Map<String, dynamic>> accounts;

  @override
  void initState() {
    super.initState();
    accounts = List.from(widget.accounts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.bankName)),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddAccountPage(bankName: widget.bankName),
                  ),
                );
                if (result != null) {
                  setState(() => accounts.add(result));
                  Navigator.pop(context, accounts);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Ajouter un compte"),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: accounts.isEmpty
                ? const Center(child: Text("Aucun compte pour cette banque"))
                : ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return AccountCard(account: accounts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}