import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../orders/data/models/order_model.dart';

class OrderAddressCard extends StatelessWidget {
  const OrderAddressCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final info = order.deliveryInfo ?? const <String, dynamic>{};
    final address = info['deliveryAddress'] as String? ?? l10n.noData;
    final postalCode = info['postalCode']?.toString();
    final fullName = info['fullName'] as String? ?? l10n.noName;
    final phone = info['phoneNumber'] as String? ?? l10n.noPhone;
    final deliveryDate =
        info['deliveryDate'] as String? ?? '19-21.03.2025, КазПочта';

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
            l10n.deliveryAddress.replaceAll(':', ''),
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            address,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFFB8B8B8),
              height: 1.4,
            ),
          ),
          if (postalCode != null && postalCode.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l10n.postalIndex(postalCode),
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
          const SizedBox(height: 18),
          _FieldLabel(l10n.recipient),
          const SizedBox(height: 6),
          Text(
            '$fullName: $phone',
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _FieldLabel(l10n.deliveryDate),
          const SizedBox(height: 6),
          Text(
            deliveryDate,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFFB8B8B8),
      ),
    );
  }
}
