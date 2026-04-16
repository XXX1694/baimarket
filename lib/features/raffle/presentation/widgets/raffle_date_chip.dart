import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../utils/raffle_date_formatter.dart';

class RaffleDateChip extends StatelessWidget {
  const RaffleDateChip({super.key, required this.iso});

  final String? iso;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final date = RaffleDateFormatter.formatDrawDate(
      context: context,
      iso: iso,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        date.isEmpty
            ? l10n.raffleDateTbd
            : l10n.raffleDateLabel(date),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
