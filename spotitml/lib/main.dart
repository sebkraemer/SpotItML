import 'package:flutter/material.dart';

void main() {
  runApp(const SpotItMLApp());
}

class SpotItMLApp extends StatelessWidget {
  const SpotItMLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpotIt ML',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'SpotItML',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
