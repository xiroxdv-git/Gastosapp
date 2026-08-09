import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos App'),
      ),
      body: const Center(
        child: Text('Bienvenido a la aplicación de gastos'),
      ),
    );
  }
}