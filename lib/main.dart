import 'package:flutter/material.dart';
import 'Screen/home_screen.dart'; // Verifica que la carpeta en tu proyecto se llame 'Screen' o 'screen'

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
        useMaterial3: true,
        // Si ya configuraste la fuente Inria Serif en pubspec.yaml, descomenta la línea siguiente:
        // fontFamily: 'InriaSerif',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 97, 85, 245),
          primary: const Color.fromARGB(255, 97, 85, 245),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}