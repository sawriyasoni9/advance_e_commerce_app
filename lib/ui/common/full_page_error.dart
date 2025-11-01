import 'package:flutter/material.dart';

class FullPageError extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetryTap;

  const FullPageError({super.key, required this.errorMessage, this.onRetryTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Icon(
              Icons.error_outline,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                errorMessage,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            ElevatedButton(onPressed: onRetryTap, child: Text('Retry')),
          ],
        ),
      ),
    );
  }
}
