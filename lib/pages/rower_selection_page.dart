import 'package:flutter/material.dart';
import 'ble_scanner_page.dart';

/// Pantalla inicial donde el usuario selecciona su rol: entrenador o remero.
/// Según la selección, se pasa el nombre del dispositivo BLE al escáner.
class RowSelectionPage extends StatelessWidget {
  final List<String> remos = [
    "Estribor-1",
    "Estribor-2",
    "Estribor-3",
    "Estribor-4",
    "Babor-1",
    "Babor-2",
    "Babor-3",
    "Babor-4",
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 210, 214, 222),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_alt, size: screenHeight * 0.028),
            SizedBox(width: 8),
            Text(
              'Selecciona tu posición en el barco',
              style: TextStyle(fontSize: screenHeight * 0.028),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            /// Botón para el entrenador (Hub central)
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, screenHeight * 0.09),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  textStyle: TextStyle(
                    fontSize: screenHeight * 0.028,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 4,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          BLEScannerPage(targetDeviceName: "Entrenador"),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8),
                    Text("Entrenador"),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            /// Botones para las posiciones de remeros (babor y estribor)
            Expanded(
              child: Row(
                children: [
                  Expanded(child: buildRemoColumn(context, "Estribor", Colors.green, screenHeight)),
                  SizedBox(width: 20),
                  Expanded(child: buildRemoColumn(context, "Babor", Colors.red, screenHeight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Construye una columna con 4 botones para las posiciones de un lado del barco.
  Widget buildRemoColumn(BuildContext context, String lado, Color color, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        final name = '$lado-${index + 1}';
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, screenHeight * 0.09),
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            textStyle: TextStyle(
              fontSize: screenHeight * 0.028,
              fontWeight: FontWeight.w600,
            ),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BLEScannerPage(targetDeviceName: name),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildAnillos(context, color, index + 1), // Decoración visual como los anillos de los remos
              SizedBox(width: 8),
              Text(name),
            ],
          ),
        );
      }),
    );
  }
}


/// Dibuja una fila de círculos de color como iconografía representativa de los remos.
Widget buildAnillos(BuildContext context, Color color, int count) {
  final screenHeight = MediaQuery.of(context).size.height;

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(count, (index) {
      return Container(
        width: screenHeight * 0.018,
        height: screenHeight * 0.018,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );
    }),
  );
}
