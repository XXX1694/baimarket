import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SimpleShimmer extends StatelessWidget {
  const SimpleShimmer({super.key, required this.borderRadius});
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: lightGray,
      highlightColor: Colors.grey.shade200,
      child: Container(
        width: double.infinity, // растягиваем на всю ширину
        height: double.infinity, // заданная высота
        decoration: BoxDecoration(
          color: lightGray,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SimpleShimmerBlack extends StatelessWidget {
  const SimpleShimmerBlack({super.key, required this.borderRadius});
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.black,
      child: Container(
        width: double.infinity, // растягиваем на всю ширину
        height: double.infinity, // заданная высота
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
