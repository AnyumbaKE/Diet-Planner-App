import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp(app: await loadApp()));
}

class MyApp extends StatelessWidget {
  final App? app;

  const MyApp({this.app, super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider()
  }
}
