import 'package:flutter/material.dart';
import '../models/account.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double totalBalance = demoAccounts.fold(0, (sum, account) => sum + account.balance);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Text(
                    'Mon patrimoine :',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${totalBalance.toStringAsFixed(2)} €',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green[200]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: demoAccounts.length,
                itemBuilder: (context, index) {
                  final account = demoAccounts[index];
                  return Card(
                    color: Colors.white.withOpacity(0.9),
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(account.name),
                      trailing: Text('${account.balance.toStringAsFixed(2)} €'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Écran "Graphiques"
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Compte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Graphiques',
          ),
        ],
      ),
    );
  }
}