import 'package:flutter/material.dart';
import 'keyboard_screen.dart';
import '../models/gasto_item.dart';
import '../services/file_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GastoItem> gastos = [];
  bool cargando = true;
  final FileManager _fileManager = FileManager();

  final List<Map<String, dynamic>> categoriasInfo = [
    {'nombre': 'Alimentación', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'nombre': 'Transporte', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'nombre': 'Hospedaje', 'icon': Icons.hotel, 'color': Colors.purple},
    {'nombre': 'Entretenimiento', 'icon': Icons.movie, 'color': Colors.pink},
    {'nombre': 'Otros', 'icon': Icons.more_horiz, 'color': Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    _cargarGastosGuardados();
  }

  Future<void> _cargarGastosGuardados() async {
    final gastosGuardados = await _fileManager.cargarGastos();
    setState(() {
      gastos = gastosGuardados;
      cargando = false;
    });
  }

  // Abrir modal para AGREGAR gasto
  Future<void> _abrirTecladoGasto() async {
    final resultado = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const Tecladopantalla(),
    );

    if (resultado != null && resultado['monto'] > 0) {
      final double monto = resultado['monto'];
      final int categoriaIndex = resultado['categoria'];
      final infoCat = categoriasInfo[categoriaIndex];

      final nuevoGasto = GastoItem(
        titulo: infoCat['nombre'],
        monto: monto,
        fecha: DateTime.now(),
        categoria: infoCat['nombre'],
      );

      setState(() {
        gastos.add(nuevoGasto);
      });

      await _fileManager.guardarGastos(gastos);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gasto de \$${monto.toStringAsFixed(2)} guardado con éxito'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Abrir modal para EDITAR gasto
  Future<void> _editarGasto(int indexReal, GastoItem gastoActual) async {
    final int catIndex = categoriasInfo.indexWhere(
      (c) => c['nombre'] == gastoActual.categoria,
    );

    final resultado = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Tecladopantalla(
        montoInicial: gastoActual.monto,
        categoriaInicial: catIndex != -1 ? catIndex : 0,
      ),
    );

    if (resultado != null && resultado['monto'] > 0) {
      final double nuevoMonto = resultado['monto'];
      final int nuevaCatIndex = resultado['categoria'];
      final infoCat = categoriasInfo[nuevaCatIndex];

      final gastoActualizado = GastoItem(
        titulo: infoCat['nombre'],
        monto: nuevoMonto,
        fecha: gastoActual.fecha,
        categoria: infoCat['nombre'],
      );

      setState(() {
        gastos[indexReal] = gastoActualizado;
      });

      await _fileManager.guardarGastos(gastos);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gasto actualizado con éxito'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ELIMINAR gasto y ofrecer opción de Deshacer
  Future<void> _eliminarGasto(int indexReal) async {
    final gastoEliminado = gastos[indexReal];

    setState(() {
      gastos.removeAt(indexReal);
    });

    await _fileManager.guardarGastos(gastos);

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gasto de \$${gastoEliminado.monto.toStringAsFixed(2)} eliminado'),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'DESHACER',
            textColor: Colors.amber,
            onPressed: () async {
              setState(() {
                gastos.insert(indexReal, gastoEliminado);
              });
              await _fileManager.guardarGastos(gastos);
            },
          ),
        ),
      );
    }
  }

  // Diálogo de confirmación para el botón de la papelera
  Future<void> _confirmarBorrado(int indexReal, GastoItem gasto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar gasto?'),
        content: Text('¿Deseas eliminar "${gasto.titulo}" por \$${gasto.monto.toStringAsFixed(2)}?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      _eliminarGasto(indexReal);
    }
  }

  double get totalGastado {
    return gastos.fold(0.0, (sum, item) => sum + item.monto);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Gastos'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 16),

                  // Tarjeta Resumen Total
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Total Gastado',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${totalGastado.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Encabezado del Historial
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Historial',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Desliza a la izquierda para borrar',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Lista de Gastos con Dismissible
                  Expanded(
                    child: gastos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long, size: 64, color: Colors.grey[300]),
                                const SizedBox(height: 12),
                                Text(
                                  'No hay gastos registrados',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: gastos.length,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            itemBuilder: (context, index) {
                              final indexReal = gastos.length - 1 - index;
                              final gasto = gastos[indexReal];
                              final catInfo = categoriasInfo.firstWhere(
                                (c) => c['nombre'] == gasto.categoria,
                                orElse: () => categoriasInfo.last,
                              );

                              return Dismissible(
                                key: ValueKey('${gasto.fecha.microsecondsSinceEpoch}_$indexReal'),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Borrar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.delete, color: Colors.white),
                                    ],
                                  ),
                                ),
                                onDismissed: (direction) {
                                  _eliminarGasto(indexReal);
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListTile(
                                    onTap: () => _editarGasto(indexReal, gasto),
                                    leading: CircleAvatar(
                                      backgroundColor: (catInfo['color'] as Color).withOpacity(0.15),
                                      child: Icon(catInfo['icon'] as IconData, color: catInfo['color'] as Color),
                                    ),
                                    title: Text(
                                      gasto.titulo,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '${gasto.fecha.day}/${gasto.fecha.month}/${gasto.fecha.year}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '-\$${gasto.monto.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                                          tooltip: 'Eliminar',
                                          onPressed: () => _confirmarBorrado(indexReal, gasto),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirTecladoGasto,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nuevo Gasto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}