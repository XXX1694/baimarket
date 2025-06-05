import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bai_market/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:bai_market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../cubit/product_cubit.dart';
import '../widgets/price_block.dart';
import '../widgets/product_image.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.id});
  final String? id;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ProductCubit cubit = ProductCubit();
  late FavoritesCubit cubit1 = FavoritesCubit();
  late ProfileCubit profileCubit = ProfileCubit();
  int? count;
  CartItemModel? item;
  bool isFavorite = false;
  @override
  void initState() {
    cubit.getProductDetail(id: int.parse(widget.id ?? '0'));
    globalCartCubit.getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,

      body: BlocConsumer<ProductCubit, ProductState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is ProductGot) {
            isFavorite = state.productModel.isInFavorite ?? false;
          }
        },
        builder: (context, state) {
          if (state is ProductGot) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: 360,
                          width: double.infinity,
                          child: ProductImagesCarousel(
                            photoUrls: state.productModel.photoUrls ?? [],
                            model: state.productModel,
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                          color: Colors.white,
                        ),

                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.productModel.name ?? l10n.productName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromARGB(255, 3, 2, 2),
                                  ),
                                ),
                                BlocConsumer<FavoritesCubit, FavoritesState>(
                                  bloc: cubit1,
                                  builder:
                                      (context, state1) => CupertinoButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          if (!isFavorite) {
                                            cubit1.addfavorite(
                                              id: state.productModel.id,
                                            );
                                          }
                                          isFavorite = !isFavorite;
                                        },
                                        child: SvgPicture.asset(
                                          isFavorite
                                              ? 'assets/icons/liked.svg'
                                              : 'assets/icons/like_product.svg',
                                          height: 28,
                                          width: 28,
                                        ),
                                      ),
                                  listener: (context, state1) {
                                    print(state1);
                                    if (state1 is FavoritesAdded) {
                                      profileCubitGlobal.getProfileData();
                                    }
                                  },
                                ),
                              ],
                            ),
                            Text(
                              TranslationUtils.getLocalizedName(
                                context: context,
                                nameKz: state.productModel.descriptionKz ?? '',
                                nameRu: state.productModel.descriptionRu ?? '',
                                nameEn: state.productModel.descriptionEn ?? '',
                              ),

                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Divider(height: 1, color: Colors.black12),
                            const SizedBox(height: 24),
                            PriceBlock(productModel: state.productModel),
                            const SizedBox(height: 24),
                            Text(
                              l10n.description,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              TranslationUtils.getLocalizedName(
                                context: context,
                                nameKz:
                                    state.productModel.detailedDescriptionKz ??
                                    '',
                                nameRu:
                                    state.productModel.detailedDescriptionRu ??
                                    '',
                                nameEn:
                                    state.productModel.detailedDescriptionEn ??
                                    '',
                              ),

                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 200),
                          ],
                        ),
                      ),
                    ),
                  ],
                  physics: const ClampingScrollPhysics(),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        context.pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/arrow_left.svg',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                state.productModel.inStockCount == null ||
                        state.productModel.inStockCount! <= 0
                    ? SizedBox()
                    : Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          right: 20,
                          left: 20,
                          top: 16,
                          bottom: 32,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.fromBorderSide(
                            BorderSide(color: lightGray),
                          ),
                        ),
                        child: BlocConsumer<CartCubit, CartState>(
                          bloc: globalCartCubit,
                          listener: (context, state1) {
                            print('state1');
                            print(state1);

                            if (state1 is CartAdded) {
                              count != null ? count = count! + 1 : null;
                              globalCartCubit.getCart();
                            }
                            if (state1 is CartRemoved) {
                              count != null ? count = count! - 1 : null;
                              globalCartCubit.getCart();
                            } else if (state1 is CartAddError) {
                              _showErrorSnackBar(context, l10n);
                            } else if (state1 is CartGot) {
                              final cart = state1.cart;
                              if (cart.cartItems != null) {
                                for (final e in cart.cartItems!) {
                                  if (e.model!.id == state.productModel.id) {
                                    item = e;
                                    count = e.quantity;
                                    break;
                                  }
                                }
                              }
                            }
                          },
                          builder: (context, state1) {
                            if (count != null && item != null && count != 0) {
                              return Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: lightGray,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Row(
                                  children: [
                                    CupertinoButton(
                                      child: SvgPicture.asset(
                                        'assets/icons/minus_gray.svg',
                                      ),
                                      onPressed: () {
                                        if (count! > 0) {
                                          globalCartCubit.removeCart(
                                            id: state.productModel.id,
                                          );
                                        }
                                      },
                                    ),

                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${state.productModel.price! * count!}₸',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: mainColorLight,
                                          ),
                                        ),
                                        Text(
                                          '$count шт',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    CupertinoButton(
                                      child: SvgPicture.asset(
                                        'assets/icons/plus_gray.svg',
                                      ),
                                      onPressed: () {
                                        globalCartCubit.addCart(
                                          id: state.productModel.id,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // Показываем кнопку "В корзину"
                              return MainButton(
                                onPressed: () {
                                  globalCartCubit.addCart(
                                    id: state.productModel.id,
                                  );
                                },
                                text: l10n.addToCart,
                              );
                            }
                          },
                        ),
                      ),
                    ),
              ],
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

void _showErrorSnackBar(BuildContext context, AppLocalizations l10n) {
  // Create an error-themed snackbar
  final snackBar = SnackBar(
    content: Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, color: Colors.white, size: 24.0),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ошибка',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  l10n.productOutOfStock,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.grey.shade900,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: BorderSide(color: Colors.red.shade300, width: 1.0),
    ),
    duration: Duration(seconds: 5),
    // action: SnackBarAction(
    //   label: 'Наза',
    //   textColor: Colors.red.shade100,
    //   onPressed: () {
    //     // Handle retry action
    //   },
    // ),
  );

  // Show the error snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void _showBeautifulSnackBar(BuildContext context, AppLocalizations l10n) {
  // Create a custom snackbar
  final snackBar = SnackBar(
    content: Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade700,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.white, size: 24.0),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Успех!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  l10n.productAddedToCart,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.blueGrey.shade700,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    duration: Duration(seconds: 2),
    action: SnackBarAction(
      label: l10n.goToCart,
      textColor: Colors.greenAccent.shade100,
      onPressed: () {
        context.go('/cart');
        // Handle undo action
      },
    ),
  );

  // Show the snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
