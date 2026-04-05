import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/urls.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../catalog/data/models/category_product_model.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import 'favorite_button.dart';

class HomeProductCard extends StatelessWidget {
  const HomeProductCard({super.key, required this.product});
  final CategoryProductModel product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: SizedBox(
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
                        if (state is FavoritesAdded ||
                            state is FavoritesDeleted) {
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? l10n.productName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    TranslationUtils.getLocalizedName(
                      context: context,
                      nameKz: product.descriptionKz ?? '',
                      nameRu: product.descriptionRu ?? '',
                      nameEn: product.descriptionEn ?? '',
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        l10n.price(product.price.toString()),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 6),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
