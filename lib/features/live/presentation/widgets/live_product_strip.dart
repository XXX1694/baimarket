import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/urls.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../catalog/data/models/category_product_model.dart';
import 'live_shopping_scope.dart';

/// Лента продуктов поверх плеера, по дизайну frame 11:
/// glass-card 200×71, белая плитка картинки 65×65, текст 11px,
/// цена в светло-голубом chip-е с градиентным текстом + перечёркнутая старая.
class LiveProductStrip extends StatelessWidget {
  const LiveProductStrip({super.key, required this.products});
  final List<CategoryProductModel> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 71,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => _LiveProductCard(product: products[i]),
      ),
    );
  }
}

class _LiveProductCard extends StatelessWidget {
  const _LiveProductCard({required this.product});
  final CategoryProductModel product;

  @override
  Widget build(BuildContext context) {
    final desc = TranslationUtils.getLocalizedName(
      context: context,
      nameKz: product.descriptionKz ?? '',
      nameRu: product.descriptionRu ?? '',
      nameEn: product.descriptionEn ?? '',
    );
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(200, 71),
      onPressed: () => openLiveProductSheet(context, product.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 200,
            height: 71,
            padding: const EdgeInsets.fromLTRB(4, 3, 7, 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  child: NetworkImageWidget(
                    url: (product.photoUrls != null &&
                            product.photoUrls!.isNotEmpty)
                        ? '$imgUrl${product.photoUrls![0]}'
                        : '',
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        desc.isNotEmpty ? desc : (product.name ?? ''),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8FEFE),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ShaderMask(
                              shaderCallback: (rect) => const LinearGradient(
                                colors: [Color(0xFF117DAA), Color(0xFF1EA396)],
                              ).createShader(rect),
                              child: Text(
                                '${product.price ?? 0}₸',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                          if (product.oldPrice != null) ...[
                            const SizedBox(width: 5),
                            Text(
                              '${product.oldPrice}₸',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.49),
                                decoration: TextDecoration.lineThrough,
                                decorationColor:
                                    Colors.white.withValues(alpha: 0.49),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
