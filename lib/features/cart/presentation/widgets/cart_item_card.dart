import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/urls.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/cart_item_model.dart';

const Color _teal = Color(0xFF3DBFAD);

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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.push('/product/${product?.id}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 110,
                width: 90,
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
          const SizedBox(width: 12),

          // Info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$totalItemPrice₸',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _teal,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    if (product?.oldPrice != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        '${product!.oldPrice}₸',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                          decoration: TextDecoration.lineThrough,
                          fontFamily: 'Gilroy',
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
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontFamily: 'Gilroy',
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
                      color: Color(0xFFFF3B30),
                      fontFamily: 'Gilroy',
                    ),
                  ),
                const SizedBox(height: 10),

                // Quantity counter
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onPressed: onRemove,
                        child: SvgPicture.asset(
                          item.quantity <= 1
                              ? 'assets/icons/cart_page/cart_page_trash.svg'
                              : 'assets/icons/cart_page/cart_page_minus.svg',
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onPressed: onAdd,
                        child: SvgPicture.asset(
                          'assets/icons/cart_page/cart_page_add.svg',
                          width: 18,
                          height: 18,
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
