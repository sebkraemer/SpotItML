import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/system_repository_impl.dart';
import 'domain/usecases/get_system_status.dart';
import 'presentation/screens/system_status_screen.dart';
import 'presentation/viewmodels/system_status_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpotIt ML',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          Provider(
            create: (_) => GetSystemStatus(SystemRepositoryImpl()),
          ),
          ChangeNotifierProvider(
            create: (context) => SystemStatusViewModel(
              context.read<GetSystemStatus>(),
            )..checkStatus(), // Check status on startup
          ),
        ],
        child: const SystemStatusScreen(),
      ),
    );
  }
}
