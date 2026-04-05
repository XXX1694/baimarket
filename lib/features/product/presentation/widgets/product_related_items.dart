import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/urls.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../catalog/data/models/category_product_model.dart';

class ProductRelatedItems extends StatelessWidget {
  const ProductRelatedItems({super.key, required this.products});
  final List<CategoryProductModel> products;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.relatedProducts,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 340,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length > 6 ? 6 : products.length,
            itemBuilder: (context, index) {
              return _RelatedProductCard(product: products[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _RelatedProductCard extends StatelessWidget {
  const _RelatedProductCard({required this.product});
  final CategoryProductModel product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plusPrice = product.price != null ? (product.price! * 0.7).round() : null;

    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 10),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => context.push('/product/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: NetworkImageWidget(
                      url: product.photoUrls != null && product.photoUrls!.isNotEmpty
                          ? '$imgUrl${product.photoUrls![0]}'
                          : '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    CupertinoIcons.heart,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Price row
            Row(
              children: [
                Text(
                  l10n.price(product.price?.toString() ?? '0'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                if (product.oldPrice != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    l10n.oldPrice(product.oldPrice.toString()),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),

            // Plus price
            if (plusPrice != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    height: 18,
                    width: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4ECDC4),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'P',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      l10n.plusPrice,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.price(plusPrice.toString()),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 6),

            // Description
            Text(
              product.name ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // Buy button
            SizedBox(
              width: double.infinity,
              height: 36,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.push('/product/${product.id}'),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFF6B6B), width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      l10n.buy,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6B6B),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
