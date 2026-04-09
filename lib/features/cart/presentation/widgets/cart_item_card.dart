import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/urls.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onAdd,
    required this.onRemove,
  });

  final CartItemModel item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final product = item.model;
    final totalItemPrice = item.quantity * (product?.price ?? 0);
    final isOutOfStock =
        product?.inStockCount == null || product!.inStockCount! <= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.push('/product/${product?.id}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 120,
                width: 120,
                child: NetworkImageWidget(
                  url: product?.photoUrls != null &&
                          product!.photoUrls!.isNotEmpty
                      ? '$imgUrl${product.photoUrls![0]}'
                      : '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$totalItemPrice₸',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: mainColorLight,
                      ),
                    ),
                    if (product?.oldPrice != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        '${product!.oldPrice}₸',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),

                // Description
                Text(
                  TranslationUtils.getLocalizedDescription(
                    context: context,
                    descriptionKz: product?.descriptionKz ?? '',
                    descriptionRu: product?.descriptionRu ?? '',
                    descriptionEn: product?.descriptionEn ?? '',
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Stock status
                if (isOutOfStock)
                  Text(
                    l10n.notAvailable,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                const SizedBox(height: 10),

                // Quantity counter
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onPressed: onRemove,
                        child: Icon(
                          item.quantity <= 1
                              ? CupertinoIcons.trash
                              : CupertinoIcons.minus,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onPressed: onAdd,
                        child: const Icon(
                          CupertinoIcons.plus,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
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
