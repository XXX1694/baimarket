import 'package:bai_market/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:bai_market/features/collection/presentation/cubit/collection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../cubit/product_cubit.dart';
import '../widgets/product_app_bar.dart';
import '../widgets/product_bottom_bar.dart';
import '../widgets/product_image_grid.dart';
import '../widgets/product_price_section.dart';
import '../widgets/product_related_items.dart';
import '../widgets/product_reviews_section.dart';
import '../widgets/product_seller_info.dart';
import '../widgets/product_tags.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.id});
  final String? id;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late final ProductCubit _productCubit = ProductCubit();
  late final FavoritesCubit _favCubit = FavoritesCubit();
  final CollectionCubit _relatedCubit = CollectionCubit();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _productCubit.getProductDetail(id: int.parse(widget.id ?? '0'));
    _relatedCubit.getCollection(slug: 'new', sort: 'popular');
    globalCartCubit.getCart();
  }

  void _toggleFavorite(int productId) {
    setState(() => _isFavorite = !_isFavorite);
    if (_isFavorite) {
      _favCubit.addfavorite(id: productId);
    } else {
      _favCubit.removeFromFavoritesById(id: productId);
    }
    profileCubitGlobal.getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ProductCubit, ProductState>(
          bloc: _productCubit,
          listener: (context, state) {
            if (state is ProductGot) {
              _isFavorite = state.productModel.isInFavorite ?? false;
            }
          },
          builder: (context, state) {
            if (state is ProductGot) {
              final product = state.productModel;
              return Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // App Bar
                      SliverToBoxAdapter(
                        child: ProductAppBar(
                          isFavorite: _isFavorite,
                          onFavoriteTap: () => _toggleFavorite(product.id),
                        ),
                      ),

                      // Image Grid
                      SliverToBoxAdapter(
                        child: ProductImageGrid(model: product),
                      ),

                      // Tags
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ProductTags(model: product),
                        ),
                      ),

                      // Price Section
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ProductPriceSection(model: product),
                        ),
                      ),

                      // Description
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Text(
                            TranslationUtils.getLocalizedName(
                              context: context,
                              nameKz: product.detailedDescriptionKz ??
                                  product.descriptionKz ??
                                  '',
                              nameRu: product.detailedDescriptionRu ??
                                  product.descriptionRu ??
                                  '',
                              nameEn: product.detailedDescriptionEn ??
                                  product.descriptionEn ??
                                  '',
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),

                      // Divider
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                      ),

                      // Seller Info (mocked)
                      SliverToBoxAdapter(
                        child: ProductSellerInfo(
                          sellerName: product.name,
                        ),
                      ),

                      // Divider
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                      ),

                      // Reviews (mocked)
                      const SliverToBoxAdapter(
                        child: ProductReviewsSection(),
                      ),

                      // Divider
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                      ),

                      // Related Products
                      SliverToBoxAdapter(
                        child: BlocBuilder<CollectionCubit, CollectionState>(
                          bloc: _relatedCubit,
                          builder: (context, relatedState) {
                            if (relatedState is CollectionGot) {
                              return ProductRelatedItems(
                                products: relatedState.collection.products,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),

                      // Bottom padding for bottom bar
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 100),
                      ),
                    ],
                  ),

                  // Bottom Bar
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ProductBottomBar(model: product),
                  ),
                ],
              );
            }

            if (state is ProductGetError) {
              return Center(
                child: Text(l10n.error('')),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
