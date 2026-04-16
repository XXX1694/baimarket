import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../l10n/app_localizations.dart';

class OrderBonusRow extends StatelessWidget {
  const OrderBonusRow({super.key, required this.tickets});

  final int tickets;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: SvgPicture.asset(
              'assets/icons/ticket.svg',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.ticketsWillBeAwarded,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            '+$tickets',
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEE6A5A),
            ),
          ),
        ],
      ),
    );
  }
}
