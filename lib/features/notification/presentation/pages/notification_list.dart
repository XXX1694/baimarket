import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class NotificationItem {
  final String notification;
  final String description;

  NotificationItem({required this.notification, required this.description});
}

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Уведомление',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: lightGray,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: seconColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/notification_icons/sale.svg',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Акции',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            SvgPicture.asset('assets/icons/ok.svg', height: 10),
                          ],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Сообщение',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onPressed: () {
                  context.push('/notification/1');
                },
              ),
              const SizedBox(height: 8),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: lightGray,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: seconColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/notification_icons/bai_market.svg',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Baai Market',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            SvgPicture.asset('assets/icons/ok.svg', height: 10),
                          ],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Только для вас',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onPressed: () {
                  context.push('/notification/2');
                },
              ),
              const SizedBox(height: 8),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: lightGray,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: seconColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/notification_icons/orders.svg',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Заказы',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            SvgPicture.asset('assets/icons/ok.svg', height: 10),
                          ],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Оплатите заказ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onPressed: () {
                  context.push('/notification/3');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
