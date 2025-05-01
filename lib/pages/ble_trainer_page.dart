import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../ble/ble_trainer_service.dart';
import '../models/metrics/trainer_metrics.dart';
import '../widgets/trainer_power_chart.dart';
import '../widgets/trainer_individual_chart.dart';

/// Pantalla que muestra métricas agregadas del barco desde el punto de vista del entrenador.
/// Incluye gráficos de potencia del equipo, escora, cabeceo y potencias individuales.

class BLETrainerPage extends StatefulWidget {
  final BluetoothDevice device;

  const BLETrainerPage({required this.device});

  @override
  State<BLETrainerPage> createState() => _BLETrainerPageState();
}

class _BLETrainerPageState extends State<BLETrainerPage> {
  TrainerMetrics? metrics;
  List<double> potenciasEquipo = [];
  List<double> potenciasBabor = [];
  List<double> potenciasEstribor = [];

  @override
  void initState() {
    super.initState();

    /// Inicia el servicio BLE que escucha los datos del entrenador.
    /// Se actualiza el estado cada vez que llegan datos nuevos.
    final service = BLETrainerService(
      device: widget.device,
      onData: (json) {
        final parsed = TrainerMetrics.fromJson(json);
        setState(() {
          metrics = parsed;

          potenciasEquipo.add(parsed.potenciaEquipo);
          potenciasBabor.add(parsed.potenciaBabor);
          potenciasEstribor.add(parsed.potenciaEstribor);

          if (potenciasEquipo.length > 10) potenciasEquipo.removeAt(0);
          if (potenciasBabor.length > 10) potenciasBabor.removeAt(0);
          if (potenciasEstribor.length > 10) potenciasEstribor.removeAt(0);
        });
      },
    );
    service.startNotifications();
  }

  @override
  void dispose() {
    widget.device.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    /// Extrae valores individuales del resumen para mostrar en la UI.
    final ritmo = metrics?.ritmo500m ?? "--:--";
    final escora = metrics?.escora.toStringAsFixed(1) ?? "--";
    final cabeceo = metrics?.cabeceo.toStringAsFixed(1) ?? "--";
    final equipo = metrics?.potenciaEquipo.toStringAsFixed(1) ?? "--";

    /// Estructura principal con gráfico de línea, gráfico de barras, cajas de datos y estado del barco.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Métricas globales"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Gráfico de evolución de potencia por banda
            SizedBox(
              height: height * 0.26,
              child: TrainerPowerChart(
                teamPower: potenciasEquipo,
                portPower: potenciasBabor,
                starboardPower: potenciasEstribor,
              ),
            ),

            const SizedBox(height: 16),
            // Título sección de potencias individuales
            Text("Potencias individuales",
                style: TextStyle(
                    fontSize: height * 0.025, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            // Gráfico de potencias individuales
            SizedBox(
              height: height * 0.26,
              child: TrainerIndividualChart(
                portValues: metrics?.babor ?? List.filled(4, 0.0),
                starboardValues: metrics?.estribor ?? List.filled(4, 0.0),
              ),
            ),
          const SizedBox(height: 24),
           
           // Cajas de resumen         
            Row(
              children: [
                _buildDataBox("Potencia Equipo", equipo, "W", height),
                _buildDataBox("Ritmo", ritmo, "min/500m", height),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildStatusBox("Escora", escora, height),
                _buildStatusBox("Cabeceo", cabeceo, height),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataBox(String label, String value, String unit, double height) {
    /// Muestra un valor con su etiqueta y unidad, estilizado como tarjeta.
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(2, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: height * 0.045, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('$label ($unit)',
                style:
                    TextStyle(fontSize: height * 0.018, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBox(String label, String value, double height) {
    /// Selecciona imagen correspondiente según el valor de escora o cabeceo.
    /// Usa imágenes desde los assets para representar visualmente la inclinación del barco.
    final double? parsedValue = double.tryParse(value);
    String asset;
    String displayText;

    if (label == "Escora") {
      if (parsedValue == null) {
        asset = 'assets/images/boat_level_escora.png';
        displayText = "Escora: --";
      } else if (parsedValue > 1.0) {
        asset = 'assets/images/boat_right_tilt.png';
        displayText = "Escora: ${parsedValue.toStringAsFixed(1)}°";
      } else if (parsedValue < -1.0) {
        asset = 'assets/images/boat_left_tilt.png';
        displayText = "Escora: ${parsedValue.toStringAsFixed(1)}°";
      } else {
        asset = 'assets/images/boat_level_escora.png';
        displayText = "Escora: Estable";
      }
    } else {
      // Cabeceo
      if (parsedValue == null) {
        asset = 'assets/images/boat_level_cabeceo.png';
        displayText = "Cabeceo: --";
      } else if (parsedValue > 1.0) {
        asset = 'assets/images/boat_bow_up.png';
        displayText = "Cabeceo: ${parsedValue.toStringAsFixed(1)}°";
      } else if (parsedValue < -1.0) {
        asset = 'assets/images/boat_stern_up.png';
        displayText = "Cabeceo: ${parsedValue.toStringAsFixed(1)}°";
      } else {
        asset = 'assets/images/boat_level_cabeceo.png';
        displayText = "Cabeceo: Estable";
      }
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(2, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(asset, height: height * 0.06),
            const SizedBox(height: 6),
            Text(displayText, style: TextStyle(fontSize: height * 0.018)),
          ],
        ),
      ),
    );
  }
}
