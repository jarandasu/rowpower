import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ble_rower_page.dart';
import 'ble_trainer_page.dart';


/// Pantalla intermedia que escanea dispositivos BLE cercanos
/// y se conecta automáticamente al dispositivo cuyo nombre coincida
/// con el recibido desde la pantalla anterior (rower o entrenador).
class BLEScannerPage extends StatefulWidget {
  final String targetDeviceName;
  const BLEScannerPage({Key? key, required this.targetDeviceName})
      : super(key: key);
  @override
  _BLEScannerPageState createState() => _BLEScannerPageState();
}

class _BLEScannerPageState extends State<BLEScannerPage> {
  List<ScanResult> devicesList = [];
  bool isScanning = false;
  bool conectado = false;

  @override
  void initState() {
    super.initState();
    startScan(); // Lanza el escaneo al entrar en la pantalla
  }


  /// Inicia el escaneo BLE, solicita permisos, y escucha resultados
  void startScan() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    // Espera a que el adaptador esté encendido
    await FlutterBluePlus.adapterState
        .where((state) => state == BluetoothAdapterState.on)
        .first;

    devicesList.clear();
    setState(() {
      isScanning = true;
    });

    // Comienza el escaneo
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    // Escucha resultados de escaneo
    FlutterBluePlus.scanResults.listen((results) async {
      for (var result in results) {
        final device = result.device;
        final name = device.platformName;

        // Si se encuentra el dispositivo, se concta a él
        if (name == widget.targetDeviceName && !conectado) {
          conectado = true;
          FlutterBluePlus.stopScan();
          await device.connect(timeout: const Duration(seconds: 10));

          // Redirige a la pantalla de visualización correspondiente
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return name == "Entrenador"
                    ? BLETrainerPage(device: device)
                    : BLERowerPage(device: device);
              },
            ),
            (route) => route.isFirst,
          );
        }
      }
      // Actualiza lista de dispositivos (si se necesita mostrar)
      setState(() {
        devicesList = results;
      });
    });
  }

  /// Detiene el escaneo manualmente desde el botón del AppBar
  void stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RowPower BLE Scanner'),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.stop : Icons.search),
            onPressed: isScanning ? stopScan : startScan,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              isScanning
                  ? '🔎 Buscando "${widget.targetDeviceName}"...'
                  : '⏳ Conectando a "${widget.targetDeviceName}"...',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
