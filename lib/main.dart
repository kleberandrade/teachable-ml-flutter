import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teachable_ml/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFLite (Cat or Dog)',
      theme: _buildTheme(),
      home: HomePage(),
    );
  }

  _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xFF212121),
      accentColor: Colors.deepOrange,
      primarySwatch: Colors.deepOrange,
    );
  }
}