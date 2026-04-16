import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/product_model.dart';
import 'review_item.dart';

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({super.key, required this.product});
  final ProductModel product;

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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                fontFamily: 'Gilroy',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Review list (preview)
        ...mockReviews
            .take(3)
            .map((review) => ReviewItem(review: review)),

        const SizedBox(height: 16),

        // Read all button
        SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.push('/product/${product.id}/reviews', extra: product),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(5),
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
