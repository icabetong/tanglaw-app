import 'package:flutter/material.dart';
import 'package:tanglaw/features/main/main.dart';

void main() {
  runApp(const TanglawApp());
}

class TanglawApp extends StatelessWidget {
  const TanglawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanglaw',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepOrange)),
      home: const MainPage(title: 'Tanglaw'),
    );
  }
}
