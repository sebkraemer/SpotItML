import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/system_status_view_model.dart';

class SystemStatusScreen extends StatelessWidget {
  const SystemStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Status'),
      ),
      body: Consumer<SystemStatusViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Version: ${viewModel.version}',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Status: ${viewModel.isInitialized ? "Initialized" : "Not Initialized"}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: viewModel.isInitialized ? Colors.green : Colors.red,
                      ),
                ),
                const SizedBox(height: 8),
                Text('Message: ${viewModel.statusMessage}',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.checkStatus(),
                  child: const Text('Refresh Status'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}