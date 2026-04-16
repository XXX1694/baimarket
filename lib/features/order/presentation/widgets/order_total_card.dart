import 'package:flutter/material.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../orders/data/models/order_model.dart';

class OrderTotalCard extends StatelessWidget {
  const OrderTotalCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final itemsTotal = order.cartItems.fold<int>(
      0,
      (sum, item) => sum + (item.model.price ?? 0),
    );
    final originalTotal = order.cartItems.fold<int>(
      0,
      (sum, item) => sum + (item.model.oldPrice ?? item.model.price ?? 0),
    );
    final discount = (originalTotal - itemsTotal).clamp(0, 1 << 31);
    final delivery =
        (order.deliveryInfo?['deliveryPrice'] as num?)?.toInt() ?? 0;
    final total = order.totalPrice;
    final savings = originalTotal > total ? originalTotal - total : 0;
    final hasDiscount = originalTotal > total;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalAmount,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          _LineRow(label: l10n.items, value: _fmt(originalTotal)),
          const SizedBox(height: 10),
          _LineRow(
            label: l10n.discount,
            value: '-${_fmt(discount)}',
            valueColor: const Color(0xFFEE6A5A),
          ),
          const SizedBox(height: 10),
          _LineRow(
            label: l10n.delivery,
            value: delivery == 0 ? l10n.free : _fmt(delivery),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                l10n.total,
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              if (hasDiscount) ...[
                Text(
                  _fmt(originalTotal),
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFB8B8B8),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                _fmt(total),
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          if (savings > 0) ...[
            const SizedBox(height: 16),
            _SavingsRow(amount: savings),
          ],
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8E8E8E),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}

class _SavingsRow extends StatelessWidget {
  const _SavingsRow({required this.amount});
  final int amount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF7A6CFB),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'P',
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            l10n.youSaved,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: mainColorDark,
            ),
          ),
          const Spacer(),
          Text(
            _fmt(amount),
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: mainColorDark,
            ),
          ),
        ],
      ),
    );
  }
}

String _fmt(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i != 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  buf.write('₸');
  return buf.toString();
}
