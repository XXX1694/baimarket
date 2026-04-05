import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/urls.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../data/models/category_product_model.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../main/presentation/widgets/favorite_button.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class CatalogProductCard extends StatelessWidget {
  const CatalogProductCard({super.key, required this.product});
  final CategoryProductModel product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plusPrice = product.price != null ? (product.price! * 0.7).round() : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Favorite
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.push('/product/${product.id}'),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: NetworkImageWidget(
                        url: product.photoUrls != null &&
                                product.photoUrls!.isNotEmpty
                            ? '$imgUrl${product.photoUrls![0]}'
                            : '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: BlocListener<FavoritesCubit, FavoritesState>(
                    listener: (context, state) {
                      if (state is FavoritesAdded || state is FavoritesDeleted) {
                        profileCubitGlobal.getProfileData();
                      }
                    },
                    child: FavoriteButton(
                      productId: product.id,
                      isFavorite: product.isInFavorite,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.price(product.price?.toString() ?? '0'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          l10n.oldPrice(product.oldPrice.toString()),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Plus price
                  if (plusPrice != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9F4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4ECDC4),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'P',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              l10n.plusPrice,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.price(plusPrice.toString()),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2ECC71),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 6),

                  // Description
                  Text(
                    TranslationUtils.getLocalizedName(
                      context: context,
                      nameKz: product.descriptionKz ?? product.name ?? '',
                      nameRu: product.descriptionRu ?? product.name ?? '',
                      nameEn: product.descriptionEn ?? product.name ?? '',
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
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
                      onPressed: () {
                        globalCartCubit.addCart(id: product.id);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            l10n.buy,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
