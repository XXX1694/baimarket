import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../cards/data/models/payment_card_model.dart';
import '../../../cards/presentation/widgets/brand_logo.dart';

class PaymentCardSelector extends StatelessWidget {
  const PaymentCardSelector({
    super.key,
    required this.card,
    required this.onTap,
  });

  /// `null` — карта не выбрана (пользователь удалил все). Показываем прочерк.
  final PaymentCardModel? card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              BrandLogo(
                brand: card?.brand ?? PaymentCardBrand.visa,
                size: const Size(60, 42),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.paymentCard,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8C8C8C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card?.maskedNumber ?? '— — — — — — —',
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF8C8C8C),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
