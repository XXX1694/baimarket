import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../l10n/app_localizations.dart';

class ProductSellerInfo extends StatelessWidget {
  const ProductSellerInfo({super.key, this.sellerName, this.orderCount});
  final String? sellerName;
  final int? orderCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = sellerName ?? 'Bai Market';
    final count = orderCount ?? 4587;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFF0F0F0),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'B',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: mainColorLight,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Gilroy'
                    ),
                  ),

                  Text(
                    l10n.sellerOrders(count.toString()),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/product_page/product_page_arrow_right.svg',
              height: 22,
              width: 22,
            ),
          ],
        ),
      ),
    );
  }
}
