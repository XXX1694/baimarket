import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';

class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const _HeartBubble(),
          const SizedBox(height: 20),
          Text(
            l10n.favoritesEmptyTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.favoritesEmptySubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black45,
              fontFamily: 'Gilroy',
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.go('/catalog'),
              child: Container(
                decoration: BoxDecoration(
                  color: mainColorLight.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    l10n.goShopping,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: mainColorLight,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartBubble extends StatelessWidget {
  const _HeartBubble();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: CustomPaint(
        painter: _BubblePainter(),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: Icon(
              Icons.favorite,
              size: 56,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFD9D9D9);
    final bubbleHeight = size.height * 0.82;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, bubbleHeight),
      const Radius.circular(24),
    );
    canvas.drawRRect(rect, paint);

    final tailPath = Path()
      ..moveTo(size.width * 0.38, bubbleHeight)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(size.width * 0.62, bubbleHeight)
      ..close();
    canvas.drawPath(tailPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
