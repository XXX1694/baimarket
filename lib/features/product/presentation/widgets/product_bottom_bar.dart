import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';

class ProductBottomBar extends StatefulWidget {
  const ProductBottomBar({super.key, required this.model});
  final ProductModel model;

  @override
  State<ProductBottomBar> createState() => _ProductBottomBarState();
}

class _ProductBottomBarState extends State<ProductBottomBar> {
  int? count;
  CartItemModel? item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.model.inStockCount == null || widget.model.inStockCount! <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BlocConsumer<CartCubit, CartState>(
        bloc: globalCartCubit,
        listener: (context, state) {
          if (state is CartAdded) {
            count != null ? count = count! + 1 : null;
            globalCartCubit.getCart();
          }
          if (state is CartRemoved) {
            count != null ? count = count! - 1 : null;
            globalCartCubit.getCart();
          } else if (state is CartAddError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.productOutOfStock),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else if (state is CartGot) {
            final cart = state.cart;
            if (cart.cartItems != null) {
              for (final e in cart.cartItems!) {
                if (e.model!.id == widget.model.id) {
                  item = e;
                  count = e.quantity;
                  break;
                }
              }
            }
          }
        },
        builder: (context, state) {
          if (count != null && item != null && count != 0) {
            // Counter mode
            return Row(
              children: [
                // Price display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.price((widget.model.price! * count!).toString()),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    if (widget.model.oldPrice != null)
                      Text(
                        l10n.oldPrice(widget.model.oldPrice.toString()),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                // Counter
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        onPressed: () {
                          if (count! > 0) {
                            globalCartCubit.removeCart(id: widget.model.id);
                          }
                        },
                        child: SvgPicture.asset('assets/icons/minus_gray.svg'),
                      ),
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        onPressed: () {
                          globalCartCubit.addCart(id: widget.model.id);
                        },
                        child: SvgPicture.asset('assets/icons/plus_gray.svg'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Buy button mode
          return Row(
            children: [
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.price(widget.model.price?.toString() ?? '0'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  if (widget.model.oldPrice != null)
                    Text(
                      l10n.oldPrice(widget.model.oldPrice.toString()),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              // Buy button
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  globalCartCubit.addCart(id: widget.model.id);
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: mainColorLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      l10n.buy,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
