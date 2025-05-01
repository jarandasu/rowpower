RowPower – Visualización BLE para Remo

RowPower es una aplicación móvil multiplataforma (Flutter) desarrollada como parte de un Trabajo de Fin de Grado (TFG). Permite conectar dispositivos de remo por Bluetooth Low Energy (BLE) y visualizar métricas clave tanto para remeros individuales como para entrenadores.

Funcionalidad:

Escaneo de dispositivos BLE por nombre (remero o entrenador).
Visualización en tiempo real de métricas individuales y colectivas.
Comparación de potencias entre babor y estribor (entrenador).
Gráficas de rendimiento con fl_chart.
Interfaz diferenciada para remeros y entrenador.
Tecnologías:

Flutter (3.x)
Dart
flutter_blue_plus para conectividad BLE
permission_handler para gestión de permisos
fl_chart para visualización de datos
Material Design adaptable
Instalación local: Requisitos:

Flutter SDK 3.x
Dispositivo Android (o emulador con BLE simulado)

Pasos:

Clonar el repositorio: git clone https://github.com/tu-usuario/rowpower.git
Navegar al proyecto: cd rowpower
Obtener dependencias: flutter pub get
Ejecutar la app: flutter run
Nota: Para Android, debe asegurarse de haber concedido permisos de localización y Bluetooth.

Seguridad: Este repositorio no contiene archivos sensibles:

Las claves privadas y archivos de firma (key.jks, key.properties) han sido excluidos.
Las carpetas de compilación (build/) y archivos generados (.apk, .aab) no están incluidos.
TFG: Este proyecto ha sido desarrollado como parte del Trabajo de Fin de Grado para la UOC, con el objetivo de explorar tecnologías de conectividad BLE, Microcontroladores y visualización deportiva.

Autor: Juan Pablo Aranda
Correo: juanpablo.aranda@yahoo.es
Universidad Oberta de Catalunya – TFG

Licencia: Este proyecto se publica solo con fines académicos. No se permite su distribución comercial sin autorización.

