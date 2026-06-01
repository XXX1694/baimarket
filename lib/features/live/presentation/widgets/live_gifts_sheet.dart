import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../catalog/data/models/category_product_model.dart';
import '../../../collection/presentation/cubit/collection_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import 'live_gift_card.dart';
import 'live_product_card.dart';
import 'live_shopping_scope.dart';
import 'sheet_close_button.dart';

/// Bottom-sheet с двумя секциями: «Товары в стриме» (frame 37) и
/// «Подарки» (frame 38). Открывается по тапу на красную кнопку «Подарок»
/// в шапке стрима.
Future<void> showLiveGiftsSheet({
  required BuildContext context,
  required CollectionCubit collectionCubit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (sheetCtx) {
      return BlocProvider.value(
        value: collectionCubit,
        child: const _LiveGiftsSheet(),
      );
    },
  );
}

class _LiveGiftsSheet extends StatelessWidget {
  const _LiveGiftsSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Товары в стриме',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SheetCloseButton(
                              onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                    ),
                    BlocBuilder<CollectionCubit, CollectionState>(
                      builder: (context, cs) {
                        if (cs is CollectionGot &&
                            cs.collection.products.isNotEmpty) {
                          return _ProductGrid(products: cs.collection.products);
                        }
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 16),
                      child: Text(
                        'Подарки',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: LiveGiftCard(
                        title: 'Бриллиант\n5 адамға',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});
  final List<CategoryProductModel> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.46,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final p = products[i];
        return BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, fs) {
            final isFav = _isFavorite(p, fs) || p.isInFavorite;
            return LiveProductCard(
              product: p,
              isFavorite: isFav,
              onFavoriteTap: () => _toggleFavorite(context, p, isFav),
              onBuyTap: () => _addToCart(context, p),
            );
          },
        );
      },
    );
  }

  bool _isFavorite(CategoryProductModel p, FavoritesState s) {
    if (s is FavoritesGot) {
      return s.favorites.any((f) => f.id == p.id);
    }
    return false;
  }

  void _toggleFavorite(
    BuildContext context,
    CategoryProductModel p,
    bool isFavorite,
  ) {
    final cubit = context.read<FavoritesCubit>();
    if (isFavorite) {
      cubit.removeFromFavoritesById(id: p.id);
    } else {
      cubit.addfavorite(id: p.id);
    }
  }

  void _addToCart(BuildContext context, CategoryProductModel p) {
    final cart = context.read<CartCubit>();
    // Грабим контекст рут-навигатора, потому что после Navigator.pop
    // локальный контекст внутри gifts-sheet будет размонтирован, а
    // открыть cart-sheet нужно поверх /live.
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    cart.addCart(id: p.id);
    Navigator.pop(context);
    openLiveCartSheet(rootContext);
  }
}
