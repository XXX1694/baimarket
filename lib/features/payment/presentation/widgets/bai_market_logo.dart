import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaiMarketLogo extends StatelessWidget {
  const BaiMarketLogo({super.key, this.height = 56});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/bai_logo.svg',
      height: height,
    );
  }
}
