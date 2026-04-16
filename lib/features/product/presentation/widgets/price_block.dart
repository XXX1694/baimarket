import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class PriceBlock extends StatelessWidget {
  const PriceBlock({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        color: seconColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Text(
            '${productModel.price} ₸ ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: mainColorLight,
            ),
          ),
          const SizedBox(width: 8),
          productModel.oldPrice != null
              ? Text(
                '${productModel.oldPrice} ₸',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                  decoration: TextDecoration.lineThrough,
                ),
              )
              : SizedBox(),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

            decoration: BoxDecoration(
              color:
                  productModel.inStockCount == null ||
                          productModel.inStockCount! <= 0
                      ? Color(0xFFF73030)
                      : mainColorLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              productModel.inStockCount == null ||
                      productModel.inStockCount! <= 0
                  ? l10n.not_in_sale
                  : l10n.in_sale,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color:
                    productModel.inStockCount == null ||
                            productModel.inStockCount! <= 0
                        ? Colors.white
                        : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
