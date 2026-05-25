import 'package:flutter/material.dart';

class RahaEmptyWidget extends StatelessWidget {
  const RahaEmptyWidget({super.key, required this.message, this.cta});
  final String message;
  final Widget? cta;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.inbox_outlined, size: 56),
        const SizedBox(height: 12),
        Text(message),
        ?cta,
      ],
    ),
  );
}
