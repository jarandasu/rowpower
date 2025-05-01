/// Modelo de datos agregados enviados por el dispositivo central del entrenador.
/// Incluye métricas de equipo, escora, cabeceo y potencias individuales.

class TrainerMetrics {
  final double potenciaEquipo;
  final double potenciaBabor;
  final double potenciaEstribor;
  final String ritmo500m;
  final double escora;
  final double cabeceo;
  final List<double> babor;
  final List<double> estribor;

  TrainerMetrics({
    required this.potenciaEquipo,
    required this.potenciaBabor,
    required this.potenciaEstribor,
    required this.ritmo500m,
    required this.escora,
    required this.cabeceo,
    required this.babor,
    required this.estribor,
  });

  factory TrainerMetrics.fromJson(Map<String, dynamic> json) {
    final resumen = json['resumen'] ?? {};
    final baborList = (json['babor'] as List<dynamic>? ?? List.filled(4, 0.0))
        .map((e) => (e as num).toDouble())
        .toList();
    final estriborList =
        (json['estribor'] as List<dynamic>? ?? List.filled(4, 0.0))
            .map((e) => (e as num).toDouble())
            .toList();

    return TrainerMetrics(
      potenciaEquipo: (resumen['equipo'] ?? 0).toDouble(),
      potenciaBabor: (resumen['babor'] ?? 0).toDouble(),
      potenciaEstribor: (resumen['estribor'] ?? 0).toDouble(),
      ritmo500m: resumen['ritmo500m'] ?? '--:--',
      escora: (resumen['escora'] ?? 0).toDouble(),
      cabeceo: (resumen['cabeceo'] ?? 0).toDouble(),
      babor: baborList.map((e) => e.toDouble()).toList(),
      estribor: estriborList.map((e) => e.toDouble()).toList(),
    );
  }
}
