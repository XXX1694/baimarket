import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/app_pallete.dart';
import 'section_card.dart';

class DeliverySection extends StatelessWidget {
  const DeliverySection({
    super.key,
    required this.selectedSegment,
    required this.onSegmentChanged,
    required this.row,
  });

  final int selectedSegment;
  final ValueChanged<int> onSegmentChanged;
  final Widget row;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          _Segmented(
            selectedSegment: selectedSegment,
            onChanged: onSegmentChanged,
          ),
          const SizedBox(height: 16),
          row,
        ],
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({required this.selectedSegment, required this.onChanged});

  final int selectedSegment;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _segment(label: 'Курьером', index: 0),
          _segment(label: 'Самавывоз', index: 1),
        ],
      ),
    );
  }

  Widget _segment({required String label, required int index}) {
    final isSelected = selectedSegment == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected ? mainColorLight : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeliveryEntryRow extends StatelessWidget {
  const DeliveryEntryRow({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.actionLabel,
    this.actionColor,
  });

  final String iconAsset;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final Color? actionColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFD8F1ED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SvgPicture.asset(iconAsset, height: 24, width: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8A8A8A),
                      height: 1.3,
                    ),
                  ),
                ],
                if (actionLabel != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    actionLabel!,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: actionColor ?? const Color(0xFF1A8FFF),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.black38,
            size: 24,
          ),
        ],
      ),
    );
  }
}
