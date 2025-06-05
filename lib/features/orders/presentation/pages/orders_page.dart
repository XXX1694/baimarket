import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/core/urls.dart';
import 'package:bai_market/core/widgets/show_image.dart';
import 'package:bai_market/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';

const Map<String, String> statusTranslate = {
  'PAYMENT_PENDING': "Ожидает оплаты",
  'PROCESSING': "Формируется",
  'WAY': "В пути",
  'PICKUP': "Ожидает в пункте выдачи",
  'DELIVERED': "Получен",
  'CANCELED': "Отменен",
  'ASSEMBLING': "Сборка заказа",
  'ABANDONED': "Сброшен",
  'PAYMENT_FAILED': "Ошибка оплаты",
};

// Map status to colors
const Map<String, Color> statusColors = {
  'PAYMENT_PENDING': Color(0xFFF39C12), // #f39c12
  'PROCESSING': Color(0xFF2980B9), // #2980b9
  'WAY': Color(0xFF27AE60), // #27ae60
  'PICKUP': Color(0xFFE67E22), // #e67e22
  'DELIVERED': Color(0xFF2ECC71), // #2ecc71
  'CANCELED': Color(0xFFE74C3C), // #e74c3c
  'ASSEMBLING': Color(0xFF5B48A2), // #5B48A2
  'ABANDONED': Color(0xFF7F8C8D), // Neutral gray for undefined statuses
  'PAYMENT_FAILED': Color(0xFFE74C3C), // Same as CANCELED for error
};

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late OrdersCubit cubit = OrdersCubit();

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  @override
  void initState() {
    cubit.getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.orderHistory,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<OrdersCubit, OrdersState>(
          bloc: cubit,
          listener: (context, state) {
            print(state);
          },
          builder: (context, state) {
            if (state is OrdersGot) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder:
                      (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: index == 0 ? 16 : 0),
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              _formatDate(state.orders[index].createdAt),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              context.push(
                                '/order',
                                extra: state.orders[index],
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8),
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              statusColors[state
                                                  .orders[index]
                                                  .status] ??
                                              Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            state.orders[index].status ==
                                                    'PAYMENT_PENDING'
                                                ? l10n.orderStatusPaymentPending
                                                : state.orders[index].status ==
                                                    'PROCESSING'
                                                ? l10n.orderStatusProcessing
                                                : state.orders[index].status ==
                                                    'WAY'
                                                ? l10n.orderStatusWay
                                                : state.orders[index].status ==
                                                    'PICKUP'
                                                ? l10n.orderStatusPickup
                                                : state.orders[index].status ==
                                                    'DELIVERED'
                                                ? l10n.orderStatusDelivered
                                                : state.orders[index].status ==
                                                    'CANCELED'
                                                ? l10n.orderStatusCanceled
                                                : state.orders[index].status ==
                                                    'ASSEMBLING'
                                                ? l10n.orderStatusAssembling
                                                : state.orders[index].status ==
                                                    'ABANDONED'
                                                ? l10n.orderStatusAbandoned
                                                : l10n.orderStatusPaymentFailed,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${state.orders[index].totalPrice} ₸',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      state.orders[index].status == 'PROCESSING'
                                          ? l10n.paid
                                          : l10n.unpaid,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    state
                                            .orders[index]
                                            .deliveryInfo?['deliveryAddress'] ??
                                        l10n.noData,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          state.orders[index].cartItems.length,
                                      itemBuilder:
                                          (context, index1) => Container(
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: lightGray,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: NetworkImageWidget(
                                                url:
                                                    '$imgUrl${state.orders[index].cartItems[index1].model.photoUrls?[0]}',
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
