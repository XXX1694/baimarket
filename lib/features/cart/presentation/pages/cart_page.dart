import 'package:bai_market/core/urls.dart';
import 'package:bai_market/core/widgets/main_button.dart';
import 'package:bai_market/core/widgets/show_image.dart';
import 'package:bai_market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_pallete.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/cart_model.dart';
import '../widgets/pay_button.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.cart,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: mainColorLight,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        l10n.freeDelivery,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => context.push('/notification'),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/ring.svg',
                          color: Color(0xFF575E6E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                color: lightGray,
                width: double.infinity,
                child: BlocConsumer<CartCubit, CartState>(
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
                    if (cart != null && cart!.cartItems!.isNotEmpty) {
                      return Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: ListView.builder(
                                itemCount: cart!.cartItems!.length,
                                itemBuilder: (context, index) {
                                  final item = cart!.cartItems![index];
                                  return Container(
                                    height: 156,
                                    margin: const EdgeInsets.only(top: 12),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        CupertinoButton(
                                          onPressed: () {
                                            context.push(
                                              '/product/${item.model?.id}',
                                            );
                                          },
                                          padding: const EdgeInsets.all(0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: SizedBox(
                                              height: 140,
                                              width: 140,
                                              child: NetworkImageWidget(
                                                url:
                                                    '$imgUrl${item.model?.photoUrls?[0]}',
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
                                              Text(
                                                '${item.quantity * (item.model?.price ?? 0)} ₸',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: mainColorLight,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                item.model?.name ?? '',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                TranslationUtils.getLocalizedDescription(
                                                  context: context,
                                                  descriptionKz:
                                                      item
                                                          .model
                                                          ?.descriptionKz ??
                                                      '',
                                                  descriptionRu:
                                                      item
                                                          .model
                                                          ?.descriptionRu ??
                                                      '',

                                                  descriptionEn:
                                                      item
                                                          .model
                                                          ?.descriptionEn ??
                                                      '',
                                                ),

                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                ),
                                                maxLines: 2,
                                              ),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await globalCartCubit
                                                          .removeCart(
                                                            id: item.model!.id,
                                                          );
                                                      setState(() {
                                                        item.quantity--;
                                                        if (item.quantity <=
                                                            0) {
                                                          cart!.cartItems!
                                                              .removeAt(index);
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 32,
                                                      width: 32,
                                                      decoration: BoxDecoration(
                                                        color: lightGray,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          'assets/icons/minus.svg',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Text(
                                                    '${item.quantity}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final added =
                                                          await globalCartCubit
                                                              .addCart(
                                                                id:
                                                                    item
                                                                        .model!
                                                                        .id,
                                                              );
                                                      if (added) {
                                                        setState(() {
                                                          item.quantity++;
                                                        });
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              l10n.cannotAddMore,
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 32,
                                                      width: 32,
                                                      decoration: BoxDecoration(
                                                        color: lightGray,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          'assets/icons/plus.svg',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    l10n.pricePerItem(
                                                      item.model?.price
                                                              ?.toString() ??
                                                          '0',
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(color: lightGray, width: 1.0),
                              ),
                            ),
                            child: PayButton(
                              onPressed: () {
                                globalCartCubit.getCartAgain();
                              },
                              text: l10n.proceedToCheckout,
                              price: calculateTotalPrice(),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/card_empty.svg'),
                              const SizedBox(height: 28),
                              Text(
                                l10n.cartEmpty,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.addedItemsWillAppearHere,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              MainButton(
                                onPressed: widget.toCatalog,
                                text: l10n.goToShopping,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int calculateTotalPrice() {
    int total = 0;
    if (cart != null) {
      for (var item in cart!.cartItems!) {
        total += (item.quantity * (item.model?.price ?? 0));
      }
    }
    return total;
  }
}
