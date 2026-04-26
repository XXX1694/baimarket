import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/data/models/cart_model.dart';
import 'section_card.dart';
import 'total_price_block.dart' show calculateTotalDiscount;

class OrderTotalSection extends StatelessWidget {
  const OrderTotalSection({
    super.key,
    required this.cartModel,
    required this.deliveryPrice,
  });

  final CartModel cartModel;
  final int deliveryPrice;

  @override
  Widget build(BuildContext context) {
    final items = cartModel.cartItems ?? const <CartItemModel>[];
    final goodsBeforeDiscount = _goodsBeforeDiscount(items);
    final discount = calculateTotalDiscount(items);
    final goodsAfterDiscount = goodsBeforeDiscount - discount;
    final totalBefore = goodsBeforeDiscount + deliveryPrice;
    final totalAfter = goodsAfterDiscount + deliveryPrice;
    final hasDiscount = discount > 0;

    return SectionCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Общая сумма',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _line(label: 'Товары', value: _formatTenge(goodsBeforeDiscount)),
          const SizedBox(height: 10),
          _line(
            label: 'Скидка',
            value: hasDiscount ? '-${_formatTenge(discount)}' : '0₸',
            valueColor: hasDiscount ? const Color(0xFFFF3B47) : Colors.black,
          ),
          const SizedBox(height: 10),
          _line(label: 'Доставка', value: _formatTenge(deliveryPrice)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEDEDED)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Итого',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              if (hasDiscount) ...[
                Text(
                  _formatTenge(totalBefore),
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9A9A9A),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                _formatTenge(totalAfter),
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          if (hasDiscount) ...[
            const SizedBox(height: 12),
            _SavedPill(amount: discount),
          ],
        ],
      ),
    );
  }

  Widget _line({
    required String label,
    required String value,
    Color valueColor = Colors.black,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  int _goodsBeforeDiscount(List<CartItemModel> items) {
    int sum = 0;
    for (final item in items) {
      final model = item.model;
      if (model == null) continue;
      final unit = model.oldPrice ?? model.price ?? 0;
      sum += unit * item.quantity;
    }
    return sum;
  }
}

class _SavedPill extends StatelessWidget {
  const _SavedPill({required this.amount});
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/main_plus.svg',
            height: 28,
            width: 28,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Вы экономили',
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2F66),
              ),
            ),
          ),
          Text(
            _formatTenge(amount),
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2F66),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatTenge(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  int count = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    buf.write(s[i]);
    count++;
    if (count == 3 && i != 0) {
      buf.write(' ');
      count = 0;
    }
  }
  final reversed = buf.toString().split('').reversed.join();
  return '$reversed₸';
}
