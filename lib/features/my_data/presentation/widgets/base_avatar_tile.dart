import 'package:flutter/material.dart';

import '../../../../core/app_pallete.dart';

class BaseAvatarTile extends StatelessWidget {
  const BaseAvatarTile({
    super.key,
    required this.initial,
    this.selected = true,
    this.onTap,
  });

  final String initial;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          color: const Color(0xFFDDF2EF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? mainColorLight : Colors.transparent,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          initial.isEmpty ? '?' : initial.characters.first.toUpperCase(),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: mainColorDark,
          ),
        ),
      ),
    );
  }
}
