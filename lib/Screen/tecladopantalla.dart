import 'package:flutter/material.dart';

class Tecladopantalla extends StatefulWidget {
  const Tecladopantalla({super.key});

  @override
  State<Tecladopantalla> createState() => _TecladopantallaState();
}

class _TecladopantallaState extends State<Tecladopantalla> {
  // 0 = Alimentación, 1 = Transporte, 2 = Hospedaje, 3 = Entretenimiento, 4 = Otros
  int categoriaSeleccionada = 0;
  String monto = '0';

  void _onNumeroPresionado(String texto) {
    setState(() {
      if (texto == '<') {
        if (monto.length > 1) {
          monto = monto.substring(0, monto.length - 1);
        } else {
          monto = '0';
        }
      } else if (texto == '.') {
        if (!monto.contains('.')) {
          monto += '.';
        }
      } else {
        if (monto == '0') {
          monto = texto;
        } else {
          monto += texto;
        }
      }
    });
  }

  Widget _buildCategoriaIcon(IconData icon, int index, String label) {
    final bool isSelected = categoriaSeleccionada == index;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        setState(() {
          categoriaSeleccionada = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: isSelected ? primaryColor : Colors.grey[200],
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? primaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTecladoRow(List<String> valores) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: valores.map((valor) {
          return InkWell(
            onTap: () => _onNumeroPresionado(valor),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              child: Text(
                valor,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Indicador visual de arrastrar modal (Línea gris superior)
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Agregar Gasto',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Cantidad Grande Dinámica
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    monto,
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'USD',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Categorías Horizontales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoriaIcon(Icons.restaurant, 0, 'Alimentación'),
                    _buildCategoriaIcon(Icons.directions_car, 1, 'Transporte'),
                    _buildCategoriaIcon(Icons.hotel, 2, 'Hospedaje'),
                    _buildCategoriaIcon(Icons.movie, 3, 'Entretenimiento'),
                    _buildCategoriaIcon(Icons.more_horiz, 4, 'Otros'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Teclado Numérico y Botones de Acción
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 245, 245, 245),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        children: [
                          _buildTecladoRow(['1', '2', '3']),
                          _buildTecladoRow(['4', '5', '6']),
                          _buildTecladoRow(['7', '8', '9']),
                          _buildTecladoRow(['.', '0', '<']),

                          const SizedBox(height: 16.0),

                          // Botón Agregar Gasto
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, {
                                  'monto': double.tryParse(monto) ?? 0.0,
                                  'categoria': categoriaSeleccionada,
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                '+ AGREGAR GASTO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12.0),

                          // Botón Cancelar
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}