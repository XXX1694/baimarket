import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'order_filter.dart';

class OrderStatusTag extends StatelessWidget {
  const OrderStatusTag({super.key, required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final group = orderFilterForStatus(status);

    final (label, color) = switch (group) {
      OrderFilter.active => (l10n.orderTagActive, const Color(0xFF5AC47D)),
      OrderFilter.completed => (l10n.orderTagCompleted, const Color(0xFFEE6A5A)),
      OrderFilter.returns => (l10n.orderTagReturn, const Color(0xFF8B7FEB)),
      OrderFilter.all => (status ?? '', const Color(0xFF9E9E9E)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Gilroy',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
