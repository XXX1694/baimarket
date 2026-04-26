import 'package:bai_market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_refresh_indicator.dart';
import '../../../collection/presentation/cubit/collection_cubit.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/cart_model.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_bottom_bar.dart';
import '../widgets/cart_empty_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_recommended.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.toCatalog});
  final VoidCallback? toCatalog;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CollectionCubit _recCubit = CollectionCubit();

  @override
  void initState() {
    super.initState();
    _recCubit.getCollection(slug: 'new', sort: 'popular');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CartCubit>().getCart();
    });
  }

  @override
  void dispose() {
    _recCubit.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<CartCubit>().getCart(),
      _recCubit.getCollection(slug: 'new', sort: 'popular'),
    ]);
  }

  int _calculateTotal(CartModel? cart) {
    final items = cart?.cartItems ?? const <CartItemModel>[];
    return items.fold(
      0,
      (sum, item) => sum + (item.quantity * (item.model?.price ?? 0)),
    );
  }

  int _calculateSaved(CartModel? cart) {
    final items = cart?.cartItems ?? const <CartItemModel>[];
    return items.fold(0, (sum, item) {
      final old = item.model?.oldPrice ?? item.model?.price ?? 0;
      final current = item.model?.price ?? 0;
      return sum + ((old - current) * item.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartGotAgain) {
              context.push('/make_order', extra: state.cart);
            }
          },
          builder: (context, state) {
            final cart = state is CartGot ? state.cart : null;
            final items = cart?.cartItems ?? const <CartItemModel>[];
            final hasItems = items.isNotEmpty;

            return Column(
              children: [
                CartAppBar(
                  showClear: hasItems,
                  onClear: () {
                    final snapshot = List<CartItemModel>.from(items);
                    for (final item in snapshot) {
                      for (int i = 0; i < item.quantity; i++) {
                        cartCubit.removeCart(id: item.model!.id);
                      }
                    }
                  },
                ),
                Expanded(
                  child: hasItems
                      ? _buildCartContent(cartCubit, items)
                      : _buildEmptyContent(),
                ),
                if (hasItems)
                  CartBottomBar(
                    totalPrice: _calculateTotal(cart),
                    savedAmount: _calculateSaved(cart),
                    onCheckout: () => cartCubit.getCartAgain(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartContent(CartCubit cartCubit, List<CartItemModel> items) {
    return AppRefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (final item in items)
                    CartItemCard(
                      key: ValueKey(item.model?.id ?? item.id),
                      item: item,
                      onAdd: () => cartCubit.addCart(
                        id: item.model!.id,
                        product: item.model,
                      ),
                      onRemove: () => cartCubit.removeCart(id: item.model!.id),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            CartRecommended(cubit: _recCubit),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyContent() {
    return AppRefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CartEmptyState(onGoShopping: () => widget.toCatalog?.call()),
            const SizedBox(height: 32),
            CartRecommended(cubit: _recCubit),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
