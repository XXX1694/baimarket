import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'tenge_format.dart';

class PaymentAmountCard extends StatefulWidget {
  const PaymentAmountCard({
    super.key,
    required this.amount,
    required this.commission,
  });
  final int amount;
  final int commission;

  @override
  State<PaymentAmountCard> createState() => _PaymentAmountCardState();
}

class _PaymentAmountCardState extends State<PaymentAmountCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.paymentAmountTitle,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8C8C8C),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _expanded = !_expanded),
                child: AnimatedRotation(
                  turns: _expanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF8C8C8C),
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatTengeWithKopecks(widget.amount),
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              height: 1.1,
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _expanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFEDEDED)),
                      const SizedBox(height: 16),
                      _row(
                        l10n.paymentSumLabel,
                        formatTengeWithKopecks(widget.amount),
                      ),
                      const SizedBox(height: 12),
                      _row(
                        l10n.paymentCommissionLabel,
                        formatTengeWithKopecks(widget.commission),
                      ),
                    ],
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8C8C8C),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
