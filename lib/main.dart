import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:number_generator/app/app.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
 
  await Hive.openBox('MyBox');
 
  runApp(
    const App(),
  );
}