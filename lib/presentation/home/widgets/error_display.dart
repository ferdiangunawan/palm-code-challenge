import 'package:flutter/material.dart';
import 'package:palm_code_challenge/common/utils/network_error_handler.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorDisplay({super.key, required this.message, required this.onRetry});

  bool _isNetworkError(String message) {
    return NetworkErrorHandler.isNetworkConnectivityError(message);
  }

  @override
  Widget build(BuildContext context) {
    final isNetworkError = _isNetworkError(message);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isNetworkError ? Icons.wifi_off : Icons.error,
            size: 64.0,
            color: isNetworkError ? Colors.orange : Colors.red,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Failed to load books',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8.0),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
