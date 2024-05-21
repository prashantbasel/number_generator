import 'package:flutter/material.dart';
import 'package:number_generator/screen/flutter_hive_screen.dart';
 
class App extends StatelessWidget {
  const App({super.key});
 
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FlutterHiveScreen(),
    );
  }
}