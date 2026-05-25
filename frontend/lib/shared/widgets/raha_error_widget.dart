import 'package:flutter/material.dart';

class RahaErrorWidget extends StatelessWidget {
  const RahaErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.warning_amber_rounded, size: 56),
        const SizedBox(height: 12),
        Text(message),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
      ],
    ),
  );
}
