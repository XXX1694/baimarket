import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/core/urls.dart';
import 'package:bai_market/core/widgets/show_image.dart';
import 'package:bai_market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bai_market/features/cart/presentation/pages/cart_page.dart';
import 'package:bai_market/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:bai_market/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/translation_utils.dart';
import '../../../../l10n/app_localizations.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late FavoritesCubit cubit = FavoritesCubit();
  late CartCubit cartCubit = CartCubit();
  @override
  void initState() {
    cubit.getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          l10n.favorites,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<FavoritesCubit, FavoritesState>(
          bloc: cubit,
          builder: (context, state) {
            if (state is FavoritesGot) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: state.favorites.length,

                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 12),
                      height: 132,

                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    context.push(
                                      '/product/${state.favorites[index].models.id}',
                                    );
                                  },
                                  child: SizedBox(
                                    height: 118,
                                    width: 118,
                                    child: ClipRRect(
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.circular(12),
                                      child: NetworkImageWidget(
                                        url:
                                            state
                                                            .favorites[index]
                                                            .models
                                                            .photoUrls !=
                                                        null &&
                                                    state
                                                        .favorites[index]
                                                        .models
                                                        .photoUrls!
                                                        .isNotEmpty
                                                ? '$imgUrl${state.favorites[index].models.photoUrls![0]}'
                                                : '',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        state.favorites[index].models.name ??
                                            l10n.productName,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        TranslationUtils.getLocalizedName(
                                          context: context,
                                          nameKz:
                                              state
                                                  .favorites[index]
                                                  .models
                                                  .descriptionKz ??
                                              l10n.productDescription,
                                          nameRu:
                                              state
                                                  .favorites[index]
                                                  .models
                                                  .descriptionRu ??
                                              l10n.productDescription,
                                          nameEn:
                                              state
                                                  .favorites[index]
                                                  .models
                                                  .descriptionEn ??
                                              l10n.productDescription,
                                        ),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54,
                                        ),
                                        maxLines: 2,
                                      ),
                                      const Spacer(),
                                      BlocConsumer<CartCubit, CartState>(
                                        bloc: cartCubit,
                                        builder:
                                            (
                                              context,
                                              state1,
                                            ) => CupertinoButton(
                                              padding: const EdgeInsets.all(0),
                                              child: Container(
                                                height: 30,
                                                width: 108,
                                                decoration: BoxDecoration(
                                                  color: seconColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    l10n.addToCart,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                cartCubit.addCart(
                                                  id:
                                                      state
                                                          .favorites[index]
                                                          .models
                                                          .id,
                                                );
                                              },
                                            ),
                                        listener: (context, state1) {
                                          if (state1 is CartAdded) {
                                            _showBeautifulSnackBar(context);
                                          } else {
                                            _showErrorSnackBar(context);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 32),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: CupertinoButton(
                              padding: const EdgeInsets.all(8),
                              onPressed: () {
                                cubit.removeFromFavorites(
                                  id: state.favorites[index].id,
                                );
                              },
                              child: SvgPicture.asset('assets/icons/liked.svg'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return SizedBox();
            }
          },
          listener: (context, state) {
            if (state is FavoritesDeleted) {
              cubit.getFavorites();
              profileCubitGlobal.getProfileData();
            }
          },
        ),
      ),
    );
  }
}

void _showErrorSnackBar(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
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
                  l10n.errorTitle,
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

void _showBeautifulSnackBar(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
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
                  l10n.success,
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
        globalCartCubit.getCart();
        context.go('/cart');
      },
    ),
  );

  // Show the snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
