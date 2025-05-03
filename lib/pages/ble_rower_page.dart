import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../ble/ble_rower_service.dart';
import '../models/metrics/rower_metrics.dart';
import '../widgets/rower_power_chart.dart';
import '../widgets/data_box.dart';

/// Pantalla de visualización para un remero.
/// Muestra potencia, fuerza, cadencia, ritmo, y media del equipo
class BLERowerPage extends StatefulWidget {
  final BluetoothDevice device;

  const BLERowerPage({required this.device});

  @override
  _BLERowerPageState createState() => _BLERowerPageState();
}

class _BLERowerPageState extends State<BLERowerPage> {
  RowerMetrics? metrics;

  /// Modelo de datos que contiene las métricas del remero
  List<double> potencias = [];

  /// Historial de potencias individuales (últimas 10)
  List<double> potenciasEquipo = [];

  /// Historial de potencias del equipo (últimas 10)

  @override
  void initState() {
    super.initState();

    /// Inicializa el servicio BLE y escucha nuevos datos JSON
    final service = BLEService(
      device: widget.device,
      onData: (json) {
        final parsed = RowerMetrics.fromJson(json);
        setState(() {
          metrics = parsed;
          potencias.add(parsed.potenciaPalada);
          potenciasEquipo.add(parsed.potenciaEquipo);
          if (potencias.length > 10) potencias.removeAt(0);
          if (potenciasEquipo.length > 10) potenciasEquipo.removeAt(0);
        });
      },
    );
    service.startNotifications();
  }
  
  
  /// Cierra la conexión BLE al salir de la pantalla
  @override
  void dispose() {
    widget.device.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    /// Calcula el promedio de las últimas 10 potencias individuales
    final promedioPalada = potencias.isNotEmpty
        ? (potencias.reduce((a, b) => a + b) / potencias.length)
            .toStringAsFixed(1)
        : "--";

    /// Estructura principal: gráfico arriba, texto medio, cajas de datos abajo
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de ${widget.device.platformName}'),
        centerTitle: true,
      ),
      body: Column(
              children: [
                Container(
                  height: height / 3,
                  padding: const EdgeInsets.all(15),
                  /// Componente gráfico que muestra potencias individuales vs equipo
                  child: RowerPowerChart(
                    potencias: potencias,
                    potenciasEquipo: potenciasEquipo,
                    deviceName: widget.device.platformName,
                  ),
                ),
                //const SizedBox(height: 6),
                Column(
                  children: [
                    /// Potencia actual del remero en pantalla grande
                    Text(
                      '${metrics?.potenciaPalada.toStringAsFixed(1) ?? "--"} W',
                      style: TextStyle(
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Promedio 10 últimas paladas: $promedioPalada W',
                      style: TextStyle(
                          fontSize: height * 0.02, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// Cajas de información con fuerza, ritmo, cadencia, etc.
                        Row(
                          children: [
                            DataBox(
                              label: "Fuerza máxima",
                              value: metrics?.fuerzaMax.toStringAsFixed(1) ?? "--",
                              unit: "N",
                              screenHeight: height,
                            ),
                            DataBox(
                              label: "Potencia Equipo",
                              value: metrics?.potenciaEquipo.toStringAsFixed(1) ?? "--",
                              unit: "W",
                              screenHeight: height,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            DataBox(
                              label: "Velocidad",
                              value: metrics?.ritmo  ?? "--",
                              unit: "min/500m",
                              screenHeight: height,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            DataBox(
                              label: "Duración",
                              value: metrics?.duracionMs.toString() ?? "--",
                              unit: "ms",
                              screenHeight: height,
                            ),
                            DataBox(
                              label: "Cadencia",
                              value: metrics?.cadencia.toStringAsFixed(1) ?? "--",
                              unit: "ppm",
                              screenHeight: height,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}


