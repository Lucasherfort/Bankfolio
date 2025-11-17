import 'package:flutter/material.dart';
import '../models/account.dart';
import '../widgets/account_list_section.dart';
import '../widgets/add_account_dialog.dart';
import 'pea_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Account> accounts = [];

  @override
  Widget build(BuildContext context) {
    // Calcul du patrimoine total (solde + intérêts pour épargne)
    double totalBalance = accounts.fold(0, (sum, a) {
      if (a.type == AccountType.Epargne) {
        return sum + a.balance + (a.interests ?? 0);
      }
      return sum + a.balance;
    });

    // Séparer épargne et investissements
    final epargneAccounts =
    accounts.where((a) => a.type == AccountType.Epargne).toList();
    final investmentAccounts =
    accounts.where((a) => a.type == AccountType.Investissement || (a.type == AccountType.Investissement && a.name == 'PEA')).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100, // fond clair
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // HEADER centré
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Mon patrimoine :',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '${totalBalance.toStringAsFixed(2)} €',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // CONTENU
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITRE ÉPARGNE toujours à gauche
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Mon épargne',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4), // petit espace entre titre et premier compte
                    AccountListSection(
                      title: '', // titre déjà géré au-dessus
                      accounts: epargneAccounts,
                      onEdit: _editAccount,
                      onDelete: _deleteAccount,
                    ),
                    const SizedBox(height: 20),

                    // TITRE INVESTISSEMENTS toujours à gauche
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Mes investissements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4), // petit espace
                    AccountListSection(
                      title: '', // titre déjà géré
                      accounts: investmentAccounts,
                      onEdit: (account) {
                        if (account.type == AccountType.Investissement && account.name == 'PEA') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PeaPage(account: account),
                            ),
                          ).then((_) => setState(() {}));
                        } else {
                          _editAccount(account);
                        }
                      },
                      onDelete: _deleteAccount,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // BOUTON AJOUTER
      floatingActionButton: FloatingActionButton(
        onPressed: _addAccount,
        backgroundColor: Colors.tealAccent.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // AJOUTER UN COMPTE
  void _addAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AddAccountDialog(
          existingAccounts: accounts,
          onAdd: (account) {
            setState(() {
              if (account.type == AccountType.Investissement && account.name == 'PEA' && account.assets == null) {
                account.assets = [];
              }
              accounts.add(account);
            });
          },
        );
      },
    );
  }

  // MODIFIER UN COMPTE
  void _editAccount(Account account) {
    if (account.type == AccountType.Investissement && account.name == 'PEA') {
      // Ouvrir la page PEA
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PeaPage(account: account),
        ),
      ).then((_) => setState(() {}));
    } else {
      // Modifier épargne
      showDialog(
        context: context,
        builder: (context) {
          return AddAccountDialog(
            existingAccounts: accounts,
            onAdd: (updatedAccount) {
              setState(() {
                account.name = updatedAccount.name;
                account.balance = updatedAccount.balance;
                account.type = updatedAccount.type;
                account.interests = updatedAccount.interests;
                account.savingsType = updatedAccount.savingsType;
                account.assets = updatedAccount.assets ?? account.assets;
              });
            },
          );
        },
      );
    }
  }

  // SUPPRIMER UN COMPTE
  void _deleteAccount(Account account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade200,
        title: const Text('Supprimer le compte', style: TextStyle(color: Colors.black87)),
        content: Text(
          'Voulez-vous vraiment supprimer "${account.name}" ?',
          style: const TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: Colors.teal)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              setState(() {
                accounts.remove(account);
              });
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

