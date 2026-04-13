import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

const Map<String, Color> statusColors = {
  'PAYMENT_PENDING': Color(0xFFF39C12),
  'PROCESSING': Color(0xFF2980B9),
  'WAY': Color(0xFF27AE60),
  'PICKUP': Color(0xFFE67E22),
  'DELIVERED': Color(0xFF2ECC71),
  'CANCELED': Color(0xFFE74C3C),
  'ASSEMBLING': Color(0xFF5B48A2),
  'ABANDONED': Color(0xFF7F8C8D),
  'PAYMENT_FAILED': Color(0xFFE74C3C),
};

String getOrderStatusText(BuildContext context, String? status) {
  final l10n = AppLocalizations.of(context)!;
  switch (status) {
    case 'PAYMENT_PENDING':
      return l10n.orderStatusPaymentPending;
    case 'PROCESSING':
      return l10n.orderStatusProcessing;
    case 'WAY':
      return l10n.orderStatusWay;
    case 'PICKUP':
      return l10n.orderStatusPickup;
    case 'DELIVERED':
      return l10n.orderStatusDelivered;
    case 'CANCELED':
      return l10n.orderStatusCanceled;
    case 'ASSEMBLING':
      return l10n.orderStatusAssembling;
    case 'ABANDONED':
      return l10n.orderStatusAbandoned;
    case 'PAYMENT_FAILED':
      return l10n.orderStatusPaymentFailed;
    default:
      return status ?? '';
  }
}
