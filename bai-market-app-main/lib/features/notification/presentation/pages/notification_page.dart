import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationItem {
  final String notification;
  final String description;

  NotificationItem({required this.notification, required this.description});
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.id});
  final String? id;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationCubit cubit = NotificationCubit();
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
          widget.id! == '1'
              ? 'Акции'
              : widget.id! == '2'
              ? 'Baai Market'
              : 'Заказы',
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
          child:
              widget.id! == '3'
                  ? BlocConsumer<NotificationCubit, NotificationState>(
                    bloc: cubit,
                    listener: (context, state) {
                      print(state);
                    },
                    builder: (context, state) {
                      if (state is NotificationGot) {
                        return ListView.builder(
                          itemCount: state.notifications.length,
                          itemBuilder:
                              (context, index) => CupertinoButton(
                                onPressed: () {},
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: index == 0 ? 20 : 0,
                                    bottom: 12,
                                  ),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: lightGray,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 12),
                                      SvgPicture.asset(
                                        'assets/icons/notification.svg',
                                        height: 32,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent,
                                          ),
                                          child: ExpansionTile(
                                            expandedAlignment:
                                                Alignment
                                                    .centerLeft, // Aligns children with the title
                                            expandedCrossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start, // Ensures left alignment
                                            maintainState: true,
                                            childrenPadding:
                                                const EdgeInsets.all(0),
                                            tilePadding: const EdgeInsets.all(
                                              0,
                                            ),

                                            title: Text(
                                              state
                                                      .notifications[index]
                                                      .title ??
                                                  '',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            minTileHeight: 28,
                                            children: [
                                              Text(
                                                state
                                                        .notifications[index]
                                                        .body ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                ),
                              ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  )
                  : null,
        ),
      ),
    );
  }
}
