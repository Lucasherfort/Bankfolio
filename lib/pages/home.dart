import 'package:flutter/material.dart';
import '../widgets/bank_card.dart';
import 'add_account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double patrimoine = 0.0; // valeur par défaut
  List<String> banks = [];
  int selectedIndex = 0;

  // Stocke les comptes par banque
  Map<String, List<Map<String, dynamic>>> bankAccounts = {};

  // --- Fonction pour mettre à jour le patrimoine ---
  void setPatrimoine(double value) {
    setState(() {
      patrimoine = value;
    });
  }

  void updatePatrimoine() {
    double total = 0.0;
    for (var accounts in bankAccounts.values) {
      total += accounts.fold(
        0.0,
            (sum, acc) => sum + (acc['amount'] as double) + (acc['interest'] as double),
      );
    }
    setPatrimoine(total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCCCFF),

      body: Column(
        children: [

          // ----------- HEADER PATRIMOINE ----------- //
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Votre patrimoine total",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${patrimoine.toStringAsFixed(2)} €",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ----------- LISTE DES BANQUES ----------- //
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: banks.length,
              itemBuilder: (context, index) {
                final bankName = banks[index];

                return BankCard(
                  bankName: bankName,
                  accounts: bankAccounts[bankName] ?? [], // <-- passer les comptes ici
                  onAddAccount: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddAccountPage(bankName: bankName)),
                    );

                    if (result != null) {
                      if (!bankAccounts.containsKey(bankName)) bankAccounts[bankName] = [];
                      bankAccounts[bankName]!.add(result);
                      updatePatrimoine();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${result['type']} ajouté à $bankName")),
                      );
                    }
                  },
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirmation"),
                        content: Text("Êtes-vous sûr de vouloir supprimer la banque $bankName ?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
                          TextButton(
                            onPressed: () {
                              if (bankAccounts.containsKey(bankName)) bankAccounts.remove(bankName);
                              updatePatrimoine();
                              setState(() => banks.removeAt(index));
                              Navigator.pop(context);
                            },
                            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ----------- BARRE DE NAVIGATION ----------- //
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Comptes"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ajouter"),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: "Graphiques"),
          BottomNavigationBarItem(icon: Icon(Icons.format_indent_increase), label: "Plan"),
        ],
        onTap: (index) {
          setState(() => selectedIndex = index);
          if (index == 1) openAddBankPanel();
        },
      ),
    );
  }

  // ----------- BOTTOM SHEET POUR AJOUTER UNE BANQUE ----------- //
  void openAddBankPanel() {
    TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Ajouter une banque",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: "Nom de la banque",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      banks.add(controller.text);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Ajouter"),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
