import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_pallete.dart';
import '../auth/auth_gate.dart';
import '../urls.dart';
import 'plus_price_badge.dart';
import '../utils/translation_utils.dart';
import 'show_image.dart';
import '../../l10n/app_localizations.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/catalog/data/models/category_product_model.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../features/main/presentation/widgets/favorite_button.dart';
import '../../features/product/data/models/product_model.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final CategoryProductModel product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plusPrice =
        product.price != null ? (product.price! * 0.7).round() : null;

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: NetworkImageWidget(
                      url: product.photoUrls != null &&
                              product.photoUrls!.isNotEmpty
                          ? '$imgUrl${product.photoUrls![0]}'
                          : '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: BlocListener<FavoritesCubit, FavoritesState>(
                    listener: (context, state) {
                      if (state is FavoritesAdded || state is FavoritesDeleted) {
                        context.read<ProfileCubit>().getProfileData();
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

            // Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.price(product.price?.toString() ?? '0'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          l10n.oldPrice(product.oldPrice.toString()),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black26,
                            decoration: TextDecoration.lineThrough,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (plusPrice != null) ...[
                    const SizedBox(height: 4),
                    PlusPriceBadge(plusPrice: plusPrice),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    TranslationUtils.getLocalizedName(
                      context: context,
                      nameKz: product.descriptionKz ?? product.name ?? '',
                      nameRu: product.descriptionRu ?? product.name ?? '',
                      nameEn: product.descriptionEn ?? product.name ?? '',
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, _) {
                      final cubit = context.read<CartCubit>();
                      final count = cubit.quantityOf(product.id);
                      if (count > 0) {
                        return _CounterRow(
                          count: count,
                          onAdd: () => cubit.addCart(
                            id: product.id,
                            product: _toProductModel(product),
                          ),
                          onRemove: () => cubit.removeCart(id: product.id),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          color: mainColorLight,
                          borderRadius: BorderRadius.circular(8),
                          onPressed: () async {
                            final ok = await ensureAuthenticated(
                              context,
                              pendingAction: () => cubit.addCart(
                                id: product.id,
                                product: _toProductModel(product),
                              ),
                            );
                            if (!ok) return;
                            cubit.addCart(
                              id: product.id,
                              product: _toProductModel(product),
                            );
                          },
                          child: Text(
                            l10n.buy,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ProductModel _toProductModel(CategoryProductModel c) => ProductModel(
      id: c.id,
      name: c.name,
      price: c.price,
      oldPrice: c.oldPrice,
      photoUrls: c.photoUrls,
      descriptionKz: c.descriptionKz,
      descriptionRu: c.descriptionRu,
      descriptionEn: c.descriptionEn,
      collections: c.collections,
      inStockCount: c.inStockCount,
      isInFavorite: c.isInFavorite,
      deal: null,
      detailedDescriptionEn: null,
      detailedDescriptionKz: null,
      detailedDescriptionRu: null,
      weightInKg: null,
      product: null,
    );

class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.count,
    required this.onAdd,
    required this.onRemove,
  });

  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onRemove,
                child: SvgPicture.asset(
                  'assets/icons/minus_gray.svg',
                  width: 14,
                ),
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'Gilroy',
              ),
            ),
            Expanded(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onAdd,
                child: SvgPicture.asset(
                  'assets/icons/plus_gray.svg',
                  width: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
