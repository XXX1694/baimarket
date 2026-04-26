import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_pallete.dart';
import '../../../../core/auth/auth_gate.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../data/models/product_model.dart';

class ProductBottomBar extends StatelessWidget {
  const ProductBottomBar({super.key, required this.model});
  final ProductModel model;

  Future<void> _addToCart(BuildContext context) async {
    final cartCubit = context.read<CartCubit>();
    final ok = await ensureAuthenticated(
      context,
      pendingAction: () => cartCubit.addCart(id: model.id, product: model),
    );
    if (!ok) return;
    cartCubit.addCart(id: model.id, product: model);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (model.inStockCount != null && model.inStockCount! <= 0) {
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
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, _) {
          final cubit = context.read<CartCubit>();
          final count = cubit.quantityOf(model.id);

          if (count > 0) {
            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.price(((model.price ?? 0) * count).toString()),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    if (model.oldPrice != null)
                      Text(
                        l10n.oldPrice(model.oldPrice.toString()),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
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
                        onPressed: () => cubit.removeCart(id: model.id),
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
                        onPressed: () => _addToCart(context),
                        child: SvgPicture.asset('assets/icons/plus_gray.svg'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.price(model.price?.toString() ?? '0'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  if (model.oldPrice != null)
                    Text(
                      l10n.oldPrice(model.oldPrice.toString()),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _addToCart(context),
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
