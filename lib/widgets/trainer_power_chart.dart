import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Line chart used on the trainer screen.
/// Displays average power from:
/// - Entire team (black)
/// - Port side (red)
/// - Starboard side (green)
class TrainerPowerChart extends StatelessWidget {
  final List<double> teamPower;
  final List<double> portPower;
  final List<double> starboardPower;

  const TrainerPowerChart({
    super.key,
    required this.teamPower,
    required this.portPower,
    required this.starboardPower,
  });

  @override
Widget build(BuildContext context) {
  return Column(
    children: [
      // El gráfico ocupa todo el alto asignado externamente
      Expanded(
        child: LineChart(
          LineChartData(
            minY: _getMinY(),
            maxY: _getMaxY(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) =>
                      Text("P${(value.toInt() + 1)}", style: const TextStyle(fontSize: 10)),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 50,
                  getTitlesWidget: (value, _) =>
                      Text("${value.toInt()} W", style: const TextStyle(fontSize: 10)),
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  teamPower.length,
                  (index) => FlSpot(index.toDouble(), teamPower[index]),
                ),
                isCurved: true,
                color: Colors.black,
                barWidth: 3,
                dotData: FlDotData(show: true),
              ),
              LineChartBarData(
                spots: List.generate(
                  portPower.length,
                  (index) => FlSpot(index.toDouble(), portPower[index]),
                ),
                isCurved: true,
                color: Colors.red,
                barWidth: 3,
                dotData: FlDotData(show: true),
              ),
              LineChartBarData(
                spots: List.generate(
                  starboardPower.length,
                  (index) => FlSpot(index.toDouble(), starboardPower[index]),
                ),
                isCurved: true,
                color: Colors.green,
                barWidth: 3,
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendDot(color: Colors.black, label: "Team Power"),
          const SizedBox(width: 16),
          _buildLegendDot(color: Colors.red, label: "Port Side"),
          const SizedBox(width: 16),
          _buildLegendDot(color: Colors.green, label: "Starboard Side"),
        ],
      ),
    ],
  );
}


  /// Icono de color + etiqueta para leyenda
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
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// Escala el eje Y en base al valor máximo
  double _getMaxY() {
    final all = [...teamPower, ...portPower, ...starboardPower];
    if (all.isEmpty) return 100;
    return all.reduce((a, b) => a > b ? a : b) + 20;
  }

double _getMinY() {
  final all = [...teamPower, ...portPower, ...starboardPower];
  if (all.isEmpty) return 0;
  final min = all.reduce((a, b) => a < b ? a : b);
  return min > 20 ? min - 20 : 0;
}



  
}
