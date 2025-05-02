import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'ble_uuids.dart';

typedef TrainerDataCallback = void Function(Map<String, dynamic> data);

/// Servicio BLE para el entrenador.
/// Escucha notificaciones del ESP32 central y convierte los datos JSON en
/// métricas agregadas del barco y de los 8 remeros.
class BLETrainerService {
  final BluetoothDevice device;
  final TrainerDataCallback onData;

  BLETrainerService({required this.device, required this.onData});

  Future<void> startNotifications() async {
    List<BluetoothService> services = await device.discoverServices();

    for (var service in services) {
      if (service.uuid.toString() == BLEUUID.trainerService) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == BLEUUID.trainerCharacteristic) {
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
