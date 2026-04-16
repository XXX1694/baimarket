import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../orders/data/models/order_model.dart';
import '../widgets/order_address_card.dart';
import '../widgets/order_bonus_row.dart';
import '../widgets/order_status_card.dart';
import '../widgets/order_total_card.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key, required this.orderModel});
  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size(32, 32),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/orders');
              }
            },
            child: SvgPicture.asset(
              'assets/icons/arrow_left.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: Text(
          l10n.orderDetails,
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              OrderAddressCard(order: orderModel),
              const SizedBox(height: 16),
              OrderStatusCard(order: orderModel),
              const SizedBox(height: 14),
              const OrderBonusRow(tickets: 2),
              const SizedBox(height: 14),
              OrderTotalCard(order: orderModel),
            ],
          ),
        ),
      ),
    );
  }
}
