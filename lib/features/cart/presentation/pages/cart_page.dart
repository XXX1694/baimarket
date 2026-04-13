import 'package:bai_market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/cart_model.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_bottom_bar.dart';
import '../widgets/cart_empty_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_recommended.dart';

final CartCubit globalCartCubit = CartCubit();

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.toCatalog});
  final VoidCallback? toCatalog;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartModel? cart;

  @override
  void initState() {
    globalCartCubit.getCart();
    super.initState();
  }

  int _calculateTotal() {
    if (cart == null || cart!.cartItems == null) return 0;
    return cart!.cartItems!.fold(
      0,
      (sum, item) => sum + (item.quantity * (item.model?.price ?? 0)),
    );
  }

  int _calculateSaved() {
    if (cart == null || cart!.cartItems == null) return 0;
    return cart!.cartItems!.fold(0, (sum, item) {
      final old = item.model?.oldPrice ?? item.model?.price ?? 0;
      final current = item.model?.price ?? 0;
      return sum + ((old - current) * item.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<CartCubit, CartState>(
          bloc: globalCartCubit,
          listener: (context, state) {
            if (state is CartGot) {
              cart = state.cart;
            }
            if (state is CartGotAgain) {
              context.push('/make_order', extra: state.cart);
            }
          },
          builder: (context, state) {
            final hasItems =
                cart != null && cart!.cartItems != null && cart!.cartItems!.isNotEmpty;

            return Column(
              children: [
                // App Bar
                CartAppBar(
                  showClear: hasItems,
                  onClear: () {
                    if (cart?.cartItems != null) {
                      for (final item in cart!.cartItems!) {
                        for (int i = 0; i < item.quantity; i++) {
                          globalCartCubit.removeCart(id: item.model!.id);
                        }
                      }
                      setState(() {
                        cart!.cartItems!.clear();
                      });
                    }
                  },
                ),

                // Content
                Expanded(
                  child: hasItems ? _buildCartContent(l10n) : _buildEmptyContent(),
                ),

                // Bottom bar
                if (hasItems)
                  CartBottomBar(
                    totalPrice: _calculateTotal(),
                    savedAmount: _calculateSaved(),
                    onCheckout: () => globalCartCubit.getCartAgain(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartContent(AppLocalizations l10n) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: cart!.cartItems!.map((item) {
                return CartItemCard(
                  item: item,
                  onAdd: () async {
                    final added = await globalCartCubit.addCart(id: item.model!.id);
                    if (added) {
                      setState(() => item.quantity++);
                    } else {
                      if (mounted) {
                        final l10n = AppLocalizations.of(context)!;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.cannotAddMore),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  onRemove: () async {
                    await globalCartCubit.removeCart(id: item.model!.id);
                    setState(() {
                      item.quantity--;
                      if (item.quantity <= 0) {
                        cart!.cartItems!.remove(item);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),

          // Recommended
          const CartRecommended(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CartEmptyState(onGoShopping: () => widget.toCatalog?.call()),
          const SizedBox(height: 32),
          const CartRecommended(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
