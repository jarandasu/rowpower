import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Bar chart used on the trainer screen to show
/// individual rower power output.
/// - Port side: red
/// - Starboard side: green
class TrainerIndividualChart extends StatelessWidget {
  final List<double> portValues;      // Babor
  final List<double> starboardValues; // Estribor

  const TrainerIndividualChart({
    super.key,
    required this.portValues,
    required this.starboardValues,
  });

 
@override
Widget build(BuildContext context) {
  final barValues = [...portValues, ...starboardValues];

  return Column(
    children: [
      // El gráfico de barras se expande dentro del espacio asignado
      Expanded(
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxY(barValues),
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    int index = value.toInt();
                    return Text(index < 4 ? "P${index + 1}" : "S${index - 3}",
                        style: const TextStyle(fontSize: 10));
                  },
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
            borderData: FlBorderData(show: true),
            barGroups: List.generate(barValues.length, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: barValues[index],
                    color: index < 4 ? Colors.red : Colors.green,
                    width: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendDot(color: Colors.red, label: "Port"),
          const SizedBox(width: 16),
          _buildLegendDot(color: Colors.green, label: "Starboard"),
        ],
      ),
    ],
  );
}



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

  double _getMaxY(List<double> values) {
    if (values.isEmpty) return 100;
    return values.reduce((a, b) => a > b ? a : b) + 20;
  }
}
