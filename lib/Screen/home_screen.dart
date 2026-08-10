import 'package:flutter/material.dart';
import 'tecladopantalla.dart'; // Asegúrate de que la ruta sea correcta si está dentro de la misma carpeta

// Modelo sencillo para representar un Gasto
class GastoItem {
  final String icon;
  final String nombre;
  final String categoria;
  final double precio;
  final String hora;

  GastoItem({
    required this.icon,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.hora,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista inicial de gastos
  final List<GastoItem> _gastos = [
    GastoItem(
      icon: '☕',
      nombre: 'Starbucks',
      categoria: 'Alimentación',
      precio: 6.50,
      hora: '9:15 AM',
    ),
    GastoItem(
      icon: '🚍',
      nombre: 'Uber',
      categoria: 'Transporte',
      precio: 2.75,
      hora: '11:30 AM',
    ),
    GastoItem(
      icon: '☕',
      nombre: 'Almuerzo',
      categoria: 'Alimentación',
      precio: 8.00,
      hora: '1:15 PM',
    ),
  ];

  // Mapeo auxiliar para convertir índice de categoría a icono y texto
  final List<Map<String, String>> _categoriasInfo = [
    {'nombre': 'Alimentación', 'icon': '☕'},
    {'nombre': 'Transporte', 'icon': '🚍'},
    {'nombre': 'Hospedaje', 'icon': '🏨'},
    {'nombre': 'Entretenimiento', 'icon': '🎬'},
    {'nombre': 'Otros', 'icon': '📦'},
  ];

  // Cálculo del total acumulado
  double get totalGastos =>
      _gastos.fold(0.0, (sum, item) => sum + item.precio);

  // Método para abrir el modal del teclado
  void _abrirTecladoAgregarGasto() async {
    final resultado = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: Tecladopantalla(),
      ),
    );

    // Verificación de seguridad para evitar errores al destruir el contexto
    if (!mounted) return;

    // Si el usuario presionó + AGREGAR GASTO y envió datos válidos
    if (resultado != null &&
        resultado['monto'] != null &&
        resultado['monto'] > 0) {
      final double montoIngresado = resultado['monto'];
      final int catIndex = resultado['categoria'] ?? 0;

      // Validación para evitar índice fuera de rango
      final infoCat = (catIndex >= 0 && catIndex < _categoriasInfo.length)
          ? _categoriasInfo[catIndex]
          : _categoriasInfo[0];

      // Formatear hora actual (ej. 4:30 PM)
      final DateTime now = DateTime.now();
      final String minFormatted = now.minute.toString().padLeft(2, '0');
      final int hour12 =
          now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
      final String amPm = now.hour >= 12 ? 'PM' : 'AM';
      final String horaActual = '$hour12:$minFormatted $amPm';

      setState(() {
        _gastos.insert(
          0,
          GastoItem(
            icon: infoCat['icon']!,
            nombre: infoCat['nombre']!,
            categoria: infoCat['nombre']!,
            precio: montoIngresado,
            hora: horaActual,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        child: FloatingActionButton.extended(
          onPressed: _abrirTecladoAgregarGasto,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          label: const Text(
            '+ AGREGAR GASTO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta principal
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 30, 30, 30),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Gastos hoy',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '\$${totalGastos.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Gastos del día',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Lista dinámica
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _gastos.length,
                  itemBuilder: (context, index) {
                    final gasto = _gastos[index];
                    return GastosCard(
                      gasto.icon,
                      nombre: gasto.nombre,
                      categoria: gasto.categoria,
                      precio: '\$${gasto.precio.toStringAsFixed(2)}',
                      hora: gasto.hora,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GastosCard extends StatelessWidget {
  final String icon;
  final String nombre;
  final String categoria;
  final String precio;
  final String hora;

  const GastosCard(
    this.icon, {
    super.key,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.hora,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 24.0)),
        title: Text(nombre),
        subtitle: Text(categoria),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              precio,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              hora,
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}