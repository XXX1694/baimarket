import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';

class CardsEmptyState extends StatelessWidget {
  const CardsEmptyState({super.key, required this.onAdd});
  final VoidCallback onAdd;

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
          const _CardsIllustration(),
          const SizedBox(height: 18),
          Text(
            l10n.cardsEmptyTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.cardsEmptySubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black45,
              fontFamily: 'Gilroy',
              height: 1.35,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onAdd,
              child: Container(
                decoration: BoxDecoration(
                  color: mainColorLight.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.addCard,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: mainColorLight,
                    fontFamily: 'Gilroy',
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

class _CardsIllustration extends StatelessWidget {
  const _CardsIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 90,
      child: Stack(
        children: [
          Positioned(
            left: 18,
            top: 4,
            child: Transform.rotate(
              angle: -0.25,
              child: Container(
                width: 74,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFCECECE),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 4,
            child: Container(
              width: 80,
              height: 54,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE9E9E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 14,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9C9C9),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 28,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9C9C9),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
