import 'package:flutter/material.dart';

class Tecladopantalla extends StatefulWidget {
  final double? montoInicial;
  final int? categoriaInicial;

  const Tecladopantalla({
    super.key,
    this.montoInicial,
    this.categoriaInicial,
  });

  @override
  State<Tecladopantalla> createState() => _TecladopantallaState();
}

class _TecladopantallaState extends State<Tecladopantalla> {
  // 0 = Alimentación, 1 = Transporte, 2 = Hospedaje, 3 = Entretenimiento, 4 = Otros
  int categoriaSeleccionada = 0;
  String monto = '0';

  @override
  void initState() {
    super.initState();
    // Si viene un monto inicial (modo edición), lo cargamos en el estado
    if (widget.montoInicial != null && widget.montoInicial! > 0) {
      final m = widget.montoInicial!;
      monto = (m % 1 == 0) ? m.toInt().toString() : m.toString();
    }
    // Si viene una categoría inicial, la seleccionamos
    if (widget.categoriaInicial != null && widget.categoriaInicial! >= 0) {
      categoriaSeleccionada = widget.categoriaInicial!;
    }
  }

  void _onNumeroPresionado(String texto) {
    setState(() {
      if (texto == 'DEL') {
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
            radius: 24,
            backgroundColor: isSelected ? primaryColor : Colors.grey[200],
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
              size: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? primaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTecladoBoton(String valor, {Widget? customWidget}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onNumeroPresionado(valor),
        customBorder: const CircleBorder(),
        child: Container(
          width: 68,
          height: 68,
          alignment: Alignment.center,
          child: customWidget ??
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildTecladoRow(List<Widget> botones) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: botones,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bool esEdicion = widget.montoInicial != null;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Indicador visual superior
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                esEdicion ? 'Editar Gasto' : 'Agregar Gasto',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Cantidad Grande Dinámica
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    monto,
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'USD',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Categorías Horizontales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F7F8),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        children: [
                          _buildTecladoRow([
                            _buildTecladoBoton('1'),
                            _buildTecladoBoton('2'),
                            _buildTecladoBoton('3'),
                          ]),
                          _buildTecladoRow([
                            _buildTecladoBoton('4'),
                            _buildTecladoBoton('5'),
                            _buildTecladoBoton('6'),
                          ]),
                          _buildTecladoRow([
                            _buildTecladoBoton('7'),
                            _buildTecladoBoton('8'),
                            _buildTecladoBoton('9'),
                          ]),
                          _buildTecladoRow([
                            _buildTecladoBoton('.'),
                            _buildTecladoBoton('0'),
                            _buildTecladoBoton(
                              'DEL',
                              customWidget: const Icon(
                                Icons.backspace_outlined,
                                size: 24,
                                color: Colors.black87,
                              ),
                            ),
                          ]),

                          const SizedBox(height: 20.0),

                          // Botón Confirmar
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                final double valorNumerico = double.tryParse(monto) ?? 0.0;
                                Navigator.pop(context, {
                                  'monto': valorNumerico,
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
                              child: Text(
                                esEdicion ? 'GUARDAR CAMBIOS' : '+ AGREGAR GASTO',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10.0),

                          // Botón Cancelar
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: Colors.black54,
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