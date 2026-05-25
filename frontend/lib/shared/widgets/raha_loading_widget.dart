import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RahaLoadingWidget extends StatelessWidget {
  const RahaLoadingWidget({super.key});
  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: 5,
    itemBuilder: (_, _) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        margin: const EdgeInsets.all(12),
        child: SizedBox(height: 96, child: Container(color: Colors.white)),
      ),
    ),
  );
}
