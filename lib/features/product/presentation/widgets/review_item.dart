import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/material.dart';

class MockReview {
  final String name;
  final String initials;
  final String date;
  final String text;
  final Color avatarColor;

  const MockReview({
    required this.name,
    required this.initials,
    required this.date,
    required this.text,
    required this.avatarColor,
  });
}

const mockReviews = [
  MockReview(
    name: 'Асылбек Д',
    initials: 'АД',
    date: '10 февраля 2026 г.',
    text: 'Отличные пакетики, прочные, легко открывается защитная лента',
    avatarColor: mainColorLight,
  ),
  MockReview(
    name: 'Асылбек Д',
    initials: 'АД',
    date: '10 февраля 2026 г.',
    text: 'Отличные пакетики, прочные, легко открывается защитная лента',
    avatarColor: mainColorLight,
  ),
  MockReview(
    name: 'Асылбек Д',
    initials: 'АД',
    date: '10 февраля 2026 г.',
    text: 'Отличные пакетики, прочные, легко открывается защитная лента',
    avatarColor: mainColorLight,
  ),
  MockReview(
    name: 'Асылбек Д',
    initials: 'АД',
    date: '10 февраля 2026 г.',
    text: 'Отличные пакетики, прочные, легко открывается защитная лента',
    avatarColor: mainColorLight,
  ),
  MockReview(
    name: 'Асылбек Д',
    initials: 'АД',
    date: '10 февраля 2026 г.',
    text: 'Отличные пакетики, прочные, легко открывается защитная лента',
    avatarColor: mainColorLight,
  ),
];

class ReviewItem extends StatelessWidget {
  const ReviewItem({super.key, required this.review, this.showDivider = false});
  final MockReview review;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDivider)
          Divider(
            color: Colors.black.withAlpha(15),
            height: 1,
            thickness: 1,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        fontFamily: 'Gilroy',
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
                            fontFamily: 'Gilroy',
                          ),
                        ),
                        Text(
                          review.date,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                review.text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
