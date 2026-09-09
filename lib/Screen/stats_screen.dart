import 'package:flutter/material.dart';
import '../models/gasto_item.dart';
import '../services/stats_isolate.dart';

class StatsScreen extends StatelessWidget {
  final List<GastoItem> gastos;

  const StatsScreen({super.key, required this.gastos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas (SO Multihilo)')),
      body: FutureBuilder<Map<String, double>>(
        future: StatsIsolateService.calcularResumenConcurrente(gastos),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error en Isolate: ${snapshot.error}'));
          }

          final desglose = snapshot.data ?? {};

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: desglose.entries.map((e) => ListTile(
              title: Text(e.key),
              trailing: Text('\$${e.value.toStringAsFixed(2)}'),
            )).toList(),
          );
        },
      ),
    );
  }
}