import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({super.key, required this.onGoShopping});

  final VoidCallback onGoShopping;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const _EmptyBoxIllustration(),
          const SizedBox(height: 20),
          Text(
            l10n.ordersEmptyTitle,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.ordersEmptyMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFFB8B8B8),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onGoShopping,
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7F2),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                l10n.goToShopping,
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: mainColorDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBoxIllustration extends StatelessWidget {
  const _EmptyBoxIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 140,
      child: CustomPaint(painter: _EmptyBoxPainter()),
    );
  }
}

class _EmptyBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final boxFill = Paint()..color = const Color(0xFFF0F0F0);
    final boxStroke = Paint()
      ..color = const Color(0xFFD5D5D5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final lidFill = Paint()..color = const Color(0xFFE0E0E0);

    final w = size.width;
    final h = size.height;

    // Box body (trapezoid-ish)
    final body = Path()
      ..moveTo(w * 0.18, h * 0.55)
      ..lineTo(w * 0.82, h * 0.55)
      ..lineTo(w * 0.88, h * 0.95)
      ..lineTo(w * 0.12, h * 0.95)
      ..close();
    canvas.drawPath(body, boxFill);
    canvas.drawPath(body, boxStroke);

    // Inner opening (darker face)
    final opening = Path()
      ..moveTo(w * 0.24, h * 0.55)
      ..lineTo(w * 0.76, h * 0.55)
      ..lineTo(w * 0.72, h * 0.66)
      ..lineTo(w * 0.28, h * 0.66)
      ..close();
    canvas.drawPath(opening, Paint()..color = const Color(0xFFDADADA));

    // Lid (tilted)
    canvas.save();
    canvas.translate(w * 0.5, h * 0.28);
    canvas.rotate(-0.18);
    final lidRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset.zero,
        width: w * 0.78,
        height: h * 0.22,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(lidRect, lidFill);
    canvas.drawRRect(lidRect, boxStroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
