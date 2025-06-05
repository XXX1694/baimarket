import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/models/profile_model.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key, required this.profile});
  final ProfileModel profile;

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    List<Map<String, dynamic>> items = [
      {
        'img': 'assets/icons/like.svg',
        'name': l10n.favorites,
        'desc': '${widget.profile.favoritesCount ?? 0} ${l10n.products}',
      },

      {
        'img': 'assets/icons/cart_2.svg',
        'name': l10n.purchases,
        'desc': l10n.orderAgain,
      },
      {
        'img': 'assets/icons/featured.svg',
        'name': l10n.myPrizes,
        'desc': l10n.noPrizes,
      },
    ];
    return SizedBox(
      height: 95,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder:
            (context, index) => CupertinoButton(
              onPressed: () {
                index == 0 ? context.push('/favorites') : null;
                index == 1 ? context.push('/orders') : null;
                index == 2 ? context.push('/prizes') : null;
              },
              padding: const EdgeInsets.all(0),
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: EdgeInsets.only(
                  left: index == 0 ? 20 : 0,
                  right: index == items.length - 1 ? 20 : 12,
                ),

                decoration: BoxDecoration(
                  color: lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(items[index]['img']),
                    SizedBox(height: 8),
                    Text(
                      items[index]['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      items[index]['desc'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
