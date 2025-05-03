import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Dibuja un gráfico de líneas con dos series:
/// - Potencia individual del remero (azul)
/// - Potencia del equipo (rojo)
/// Muestra también una leyenda informativa.
class RowerPowerChart extends StatelessWidget {
  final List<double> potencias;
  final List<double> potenciasEquipo;
  final String deviceName;

  const RowerPowerChart({
    Key? key,
    required this.potencias,
    required this.potenciasEquipo,
    required this.deviceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Gráfico de línea
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: LineChart(
            LineChartData(
              minY: _getMinY(),
              maxY: _getMaxY(), // Altura del eje Y calculada dinámicamente
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                       // Etiquetas como P-1, P-2 en el eje X
                      int index = value.toInt();
                      int offset = potencias.length;
                      int label = index - offset + 1;
                      return Text("P$label", style: TextStyle(fontSize: 10));
                    },
                  ),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 50,
                    getTitlesWidget: (value, _) => Text("${value.toInt()} W",
                        style: TextStyle(fontSize: 10)),
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                 // Línea azul = potencia individual del remero
                LineChartBarData(
                  spots: List.generate(
                    potencias.length,
                    (index) => FlSpot(index.toDouble(), potencias[index]),
                  ),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
                // Línea roja = potencia del equipo
                LineChartBarData(
                  spots: List.generate(
                    potenciasEquipo.length,
                    (index) => FlSpot(index.toDouble(), potenciasEquipo[index]),
                  ),
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),

        // Leyenda centrada debajo del gráfico
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendDot(color: Colors.blue, label: "Potencia $deviceName"),
            const SizedBox(width: 16),
            _buildLegendDot(color: Colors.red, label: "Potencia media del Equipo"),
          ],
        ),
      ],
    );
  }

  // Construye un ícono de leyenda (círculo de color + etiqueta)
  Widget _buildLegendDot({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 20)),
      ],
    );
  }

// Calcula el valor máximo y mínimo para escalar el gráfico
  double _getMaxY() {
    final allValues = [...potencias, ...potenciasEquipo];
    if (allValues.isEmpty) return 100;
    return allValues.reduce((a, b) => a > b ? a : b) + 20;
  }

  double _getMinY() {
  final allValues = [...potencias, ...potenciasEquipo];
  if (allValues.isEmpty) return 0;
  final min = allValues.reduce((a, b) => a < b ? a : b);
  return (min - 20).clamp(0, double.infinity);
}

}
