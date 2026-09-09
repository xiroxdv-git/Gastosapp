import 'package:flutter/foundation.dart';
import '../models/gasto_item.dart';

/// Función global que se ejecutará en un hilo de trabajo independiente (Isolate)
Map<String, double> _procesarCalculoParalelo(List<GastoItem> listaGastos) {
  final Map<String, double> acumulado = {};

  for (var gasto in listaGastos) {
    acumulado[gasto.categoria] = (acumulado[gasto.categoria] ?? 0.0) + gasto.precio;
  }

  return acumulado;
}

class StatsIsolateService {
  /// Asigna la tarea pesada a un nuevo Isolate del Kernel para no bloquear el Hilo Principal (UI)
  static Future<Map<String, double>> calcularResumenConcurrente(List<GastoItem> gastos) async {
    if (gastos.isEmpty) return {};
    
    // compute() crea el Isolate, envía los datos, ejecuta la función y destruye el Isolate
    return await compute(_procesarCalculoParalelo, gastos);
  }
}