import 'package:flutter/material.dart';
import 'Screen/home_screen.dart';

void main() {
  runApp(const Gastosapp());
}

class Gastosapp extends StatelessWidget {
  const Gastosapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gastos App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 97, 85, 245),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 97, 85, 245)),
        useMaterial3: true,
        // Configuración de la fuente por defecto
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}