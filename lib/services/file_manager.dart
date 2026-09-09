import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gasto_item.dart';

class FileManager {
  static const String _keyGastos = 'lista_gastos_persistent';

  // Guardar la lista de gastos
  Future<void> guardarGastos(List<GastoItem> gastos) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> listaMapas =
        gastos.map((g) => g.toJson()).toList();
    final String jsonString = jsonEncode(listaMapas);
    await prefs.setString(_keyGastos, jsonString);
  }

  // Cargar la lista de gastos
  Future<List<GastoItem>> cargarGastos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_keyGastos);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decodedList = jsonDecode(jsonString);
      return decodedList
          .map((item) => GastoItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Borrar todos los gastos (opcional)
  Future<void> borrarGastos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGastos);
  }
}