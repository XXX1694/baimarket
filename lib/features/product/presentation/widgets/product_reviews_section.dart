import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class _MockReview {
  final String name;
  final String initials;
  final String date;
  final String text;
  final Color avatarColor;

  const _MockReview({
    required this.name,
    required this.initials,
    required this.date,
    required this.text,
    required this.avatarColor,
  });
}

const _mockReviews = [
  _MockReview(
    name: 'Асылбек Д',
    initials: 'АД',
    date: '10 февраля 2026 г.',
    text: 'Отличные пакетики, прочные, легко открывается защитная лента',
    avatarColor: Color(0xFF4ECDC4),
  ),
  _MockReview(
    name: 'Асылбек Д',
    initials: 'АД',
    date: '10 февраля 2026 г.',
    text: 'Отличные пакетики, прочные, легко открывается защитная лента',
    avatarColor: Color(0xFF4ECDC4),
  ),
  _MockReview(
    name: 'Асылбек Д',
    initials: 'АД',
    date: '10 февраля 2026 г.',
    text: 'Отличные пакетики, прочные, легко открывается защитная лента',
    avatarColor: Color(0xFF4ECDC4),
  ),
];

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const reviewCount = 28;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                l10n.reviews,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                l10n.reviewsCount(reviewCount.toString()),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Review list
          ..._mockReviews.map((review) => _ReviewCard(review: review)),

          const SizedBox(height: 12),

          // Read all button
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    l10n.readAll,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final _MockReview review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: review.avatarColor,
                child: Text(
                  review.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    review.date,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
