import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'ble_uuids.dart';

typedef RowerMetricsCallback = void Function(Map<String, dynamic> jsonData);


/// Servicio BLE para remeros.
/// Escucha notificaciones del ESP32 individual de cada remero.
/// Convierte los datos JSON recibidos en métricas personales (potencia, ritmo, etc.)
class BLEService {
  final BluetoothDevice device;
  final RowerMetricsCallback onData;

  BLEService({required this.device, required this.onData});

  /// Descubre servicios BLE y comienza a escuchar la característica del remero.
  Future<void> startNotifications() async {
    List<BluetoothService> services = await device.discoverServices();

    for (var service in services) {
      if (service.uuid.toString() == BLEUUID.remeroService) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == BLEUUID.remeroCharacteristic) {
            await characteristic.setNotifyValue(true);


            characteristic.onValueReceived.listen((value) {
              final jsonStr = utf8.decode(value);
              final Map<String, dynamic> decoded = json.decode(jsonStr);
              onData(decoded);
            });
          }
        }
      }
    }
  }
}
