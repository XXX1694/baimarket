import 'package:bai_market/core/app_pallete.dart';
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
    avatarColor: mainColorLight,
  ),
  _MockReview(
    name: 'Асылбек Д',
    initials: 'АД',
    date: '10 февраля 2026 г.',
    text: 'Отличные пакетики, прочные, легко открывается защитная лента',
    avatarColor: mainColorLight,
  ),
  _MockReview(
    name: 'Асылбек Д',
    initials: 'АД',
    date: '10 февраля 2026 г.',
    text: 'Отличные пакетики, прочные, легко открывается защитная лента',
    avatarColor: mainColorLight,
  ),
];

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const reviewCount = 28;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Text(
              l10n.reviews,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'Gilroy',
              ),
            ),
            const Spacer(),
            Text(
              l10n.reviewsCount(reviewCount.toString()),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                 fontFamily: 'Gilroy',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Review list
        ..._mockReviews.map((review) => _ReviewItem(review: review)),

        const SizedBox(height: 16),

        // Read all button
        SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color:  Colors.black.withAlpha(5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  l10n.readAll,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({required this.review});
  final _MockReview review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: review.avatarColor,
            child: Text(
              review.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy'
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                         fontFamily: 'Gilroy'
                  ),
                ),
                Text(
                  review.date,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                         fontFamily: 'Gilroy'
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  review.text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
  fontFamily: 'Gilroy'
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
