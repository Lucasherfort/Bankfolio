import 'package:flutter/material.dart';
import 'package:myapplication/pages/savings_account.dart';
import '../widgets/savings_card.dart';
import '../widgets/investments_card.dart';
import 'Savings_Info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double patrimoine = 0.0;

  // 🔥 Les deux nouvelles listes
  List<SavingsAccount> savingsAccounts = [];
  List<SavingsAccount> investmentsAccounts = [];

  int selectedIndex = 0;

  // --- Mettre à jour le patrimoine ---
  void updatePatrimoine() {
    double total = 0.0;

    for (var acc in savingsAccounts) {
      total += acc.amount + acc.interest;
    }
    for (var acc in investmentsAccounts) {
      total += acc.amount + acc.interest;
    }

    setState(() => patrimoine = total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCCCFF),
      body: Column(
        children: [
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Votre patrimoine total",
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 5),
                  Text(
                    "${patrimoine.toStringAsFixed(2)} €",
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // ----------- CARTES ----------- //
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SavingsCard(
                  accounts: savingsAccounts,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SavingsInfoPage(
                          accounts: savingsAccounts, onAdd: (SavingsAccount p1) {  },
                        ),
                      ),
                    );

                    if (result != null) {
                      setState(() => savingsAccounts = result);
                      updatePatrimoine();
                    }
                  },
                ),
                const SizedBox(height: 20),
                InvestmentsCard(
                  accounts: investmentsAccounts,
                  onTap: () {
                    // Plus tard : page investments
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph_outlined), label: "Graphiques"),
        ],
        onTap: (index) {
          setState(() => selectedIndex = index);
          if (index == 1) {
            // Ajouter un compte épargne
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SavingsInfoPage(
                  accounts: savingsAccounts, onAdd: (SavingsAccount p1) {  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}