import 'package:flutter/material.dart';
import 'package:myapplication/pages/home.dart';

// Fonction main
void main()
{
  // Lancer l'application
  runApp(MyApp());
}

// Widget static
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Titre de l'application 
      title: 'MyAppAPI',
      // Banniere de debug
      debugShowCheckedModeBanner: false,
      // Page d'accueil
      // Scaffold = page vierge
      home: HomePage(),
    );
  }
}