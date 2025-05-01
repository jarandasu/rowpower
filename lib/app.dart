import 'package:flutter/material.dart';
import 'pages/rower_selection_page.dart';

class RowPowerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RowPower',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue.shade800,
        scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 243),
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
        ),
      ),
      home: RowSelectionPage(),
    );
  }
}
