import 'package:flutter/material.dart';
import '../models/account.dart';
import '../widgets/account_list_section.dart';
import '../widgets/add_account_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Account> accounts = [];

  @override
  Widget build(BuildContext context) {
    // Séparer les comptes par type
    List<Account> savingsAccounts =
    accounts.where((a) => a.type == AccountType.Epargne).toList();
    List<Account> investmentAccounts =
    accounts.where((a) => a.type == AccountType.Investissement).toList();

    double totalSavings = savingsAccounts.fold(
        0, (sum, account) => sum + account.balance + (account.interests ?? 0));
    double totalInvestments =
    investmentAccounts.fold(0, (sum, account) => sum + account.balance);

    final List<Widget> _pages = [
      // Écran "Compte"
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 40),
          children: [
            // Patrimoine total
            Center(
              child: Column(
                children: [
                  const Text(
                    'Mon patrimoine :',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(totalSavings + totalInvestments).toStringAsFixed(2)} €',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[200]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Section Mon épargne
            AccountListSection(
              title: 'Mon épargne',
              accounts: savingsAccounts,
              onEdit: _editAccount,
              onDelete: _deleteAccount,
            ),

            // Section Mes investissements
            AccountListSection(
              title: 'Mes investissements',
              accounts: investmentAccounts,
              onEdit: _editAccount,
              onDelete: _deleteAccount,
            ),
          ],
        ),
      ),

      // Écran Graphiques
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Text(
            'Graphiques à venir...',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'Compte'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Graphiques'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () => _addAccount(),
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  void _addAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AddAccountDialog(
          existingAccounts: accounts, // <-- ici
          onAdd: (account) {
            setState(() {
              accounts.add(account);
            });
          },
        );
      },
    );
  }

  void _editAccount(Account account) {
    showDialog(
      context: context,
      builder: (context) {
        return AddAccountDialog(
          account: account,
          existingAccounts: accounts, // <-- ici aussi
          onAdd: (updatedAccount) {
            setState(() {
              account.name = updatedAccount.name;
              account.balance = updatedAccount.balance;
              account.interests = updatedAccount.interests;
              account.type = updatedAccount.type;
              account.savingsType = updatedAccount.savingsType;
            });
          },
        );
      },
    );
  }

  void _deleteAccount(Account account) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le compte'),
          content: Text('Voulez-vous vraiment supprimer "${account.name}" ?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                setState(() => accounts.remove(account));
                Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
