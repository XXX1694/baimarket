import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/app_pallete.dart';
import 'section_card.dart';

enum PaymentMethod { card, kaspi, halyk }

class PaymentMethodsSection extends StatelessWidget {
  const PaymentMethodsSection({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Способы оплаты',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6E6E6E),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _MethodCard(
                  isSelected: selected == PaymentMethod.card,
                  onTap: () => onChanged(PaymentMethod.card),
                  label: 'Картой онлайн',
                  icon: SvgPicture.asset(
                    'assets/icons/create_order/create_order_card.svg',
                    height: 28,
                    width: 28,
                  ),
                ),
                const SizedBox(width: 8),
                _MethodCard(
                  isSelected: selected == PaymentMethod.kaspi,
                  onTap: () => onChanged(PaymentMethod.kaspi),
                  label: 'Kaspi Bank',
                  icon: SvgPicture.asset(
                    'assets/icons/create_order/kaspi.svg',
                    height: 28,
                    width: 28,
                  ),
                ),
                const SizedBox(width: 8),
                _MethodCard(
                  isSelected: selected == PaymentMethod.halyk,
                  onTap: () => onChanged(PaymentMethod.halyk),
                  label: 'Halyk Bank',
                  icon: SvgPicture.asset(
                    'assets/icons/create_order/halyk.svg',
                    height: 28,
                    width: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.isSelected,
    required this.onTap,
    required this.label,
    required this.icon,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 132,
        decoration: BoxDecoration(
          color: lightGray,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? mainColorLight : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
