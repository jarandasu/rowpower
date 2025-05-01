/// Modelo de datos para métricas de un remero individual.
/// Se construye a partir de un JSON enviado vía BLE.

class RowerMetrics {
  final double potenciaPalada;
  final double potenciaEquipo;
  final double fuerzaMax;
  final String ritmo;
  final int duracionMs;
  final double cadencia;

  RowerMetrics({
    required this.potenciaPalada,
    required this.potenciaEquipo,
    required this.fuerzaMax,
    required this.ritmo,
    required this.duracionMs,
    required this.cadencia,
  });

  factory RowerMetrics.fromJson(Map<String, dynamic> json) {
    return RowerMetrics(
      potenciaPalada: (json['potenciaPalada'] ?? 0).toDouble(),
      potenciaEquipo: (json['potenciaEquipo'] ?? 0).toDouble(),
      fuerzaMax: (json['fuerzaMax'] ?? 0).toDouble(),
      ritmo: json['ritmo'] ?? "--:--",
      duracionMs: (json['duracionMs'] ?? 0),
      cadencia: (json['cadencia'] ?? 0).toDouble(),
    );
  }
}
