import 'package:flutter/material.dart';


/// Widget reutilizable para mostrar un dato en una tarjeta.
/// Muestra:
/// - un valor numérico grande
/// - una etiqueta y tras el valor su unidad
class DataBox extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double screenHeight;

  const DataBox({
    Key? key,
    required this.label,
    required this.value,
    required this.unit,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double valueFontSize = screenHeight * 0.045;
    final double labelFontSize = screenHeight * 0.020;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: valueFontSize, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('$label ($unit)',
                style: TextStyle(fontSize: labelFontSize, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
