import 'package:bai_market/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:bai_market/features/collection/presentation/cubit/collection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
    _relatedCubit.getCollection(slug: 'all', sort: 'popular');
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

  Widget _block(Widget child, {bool noRadius = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(noRadius ? 0 : 12),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
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
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // AppBar
                        SliverToBoxAdapter(
                          child: ProductAppBar(
                            isFavorite: _isFavorite,
                            onFavoriteTap: () => _toggleFavorite(product.id),
                          ),
                        ),

                        // Image Grid — on gray background
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: ProductImageGrid(model: product),
                          ),
                        ),

                        // Block 2: Tags + Price + Description
                        SliverToBoxAdapter(
                          child: _block(
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductTags(model: product),
                                  const SizedBox(height: 12),
                                  ProductPriceSection(model: product),
                                  const SizedBox(height: 12),
                                  Text(
                                    () {
                                      final desc = TranslationUtils.getLocalizedName(
                                        context: context,
                                        nameKz: product.detailedDescriptionKz ??
                                            product.descriptionKz ?? '',
                                        nameRu: product.detailedDescriptionRu ??
                                            product.descriptionRu ?? '',
                                        nameEn: product.detailedDescriptionEn ??
                                            product.descriptionEn ?? '',
                                      );
                                      return desc.trim().isEmpty
                                          ? l10n.defaultDescription
                                          : desc;
                                    }(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: 'Gilroy',
                                      height: 1.5,
                                    ),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 10)),

                        // Block 3: Seller Info
                        SliverToBoxAdapter(
                          child: _block(
                            ProductSellerInfo(sellerName: product.name),
                          ),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 10)),

                        // Block 4: Reviews
                        SliverToBoxAdapter(
                          child: _block(
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: ProductReviewsSection(),
                            ),
                          ),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 8)),

                        // Block 5: Related Products
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      ],
                    ),
                  ),

                  // Bottom Bar — pinned to bottom
                  ProductBottomBar(model: product),
                ],
              );
            }

            if (state is ProductGetError) {
              return Center(child: Text(l10n.error('')));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
