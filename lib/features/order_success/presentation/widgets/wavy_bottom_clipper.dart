import 'package:flutter/material.dart';

/// Билетный край: ряд полукруглых вырезов вверх вдоль нижней стороны
/// с короткими ровными участками между вырезами (чтобы не было острых пиков).
class WavyBottomClipper extends CustomClipper<Path> {
  const WavyBottomClipper({
    this.scallopRadius = 7,
    this.topRadius = 18,
    this.flatGap = 4,
  });
  final double scallopRadius;
  final double topRadius;
  final double flatGap;

  @override
  Path getClip(Size size) {
    final r = scallopRadius;
    final tr = topRadius;
    final bottom = size.height;
    final cellTarget = 2 * r + flatGap;
    final steps = (size.width / cellTarget).floor().clamp(1, 200);
    final cellW = size.width / steps;
    final flatSide = (cellW - 2 * r) / 2;

    final path = Path()
      ..moveTo(tr, 0)
      ..lineTo(size.width - tr, 0)
      ..arcToPoint(
        Offset(size.width, tr),
        radius: Radius.circular(tr),
        clockwise: true,
      )
      ..lineTo(size.width, bottom);

    var curX = size.width;
    for (int i = 0; i < steps; i++) {
      curX -= flatSide;
      path.lineTo(curX, bottom);
      final arcEnd = curX - 2 * r;
      path.arcToPoint(
        Offset(arcEnd, bottom),
        radius: Radius.circular(r),
        clockwise: false,
      );
      curX = arcEnd;
      curX -= flatSide;
      path.lineTo(curX, bottom);
    }

    path
      ..lineTo(0, tr)
      ..arcToPoint(
        Offset(tr, 0),
        radius: Radius.circular(tr),
        clockwise: true,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant WavyBottomClipper oldClipper) =>
      oldClipper.scallopRadius != scallopRadius ||
      oldClipper.topRadius != topRadius ||
      oldClipper.flatGap != flatGap;
}
