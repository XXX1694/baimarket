import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_pallete.dart';

class PayButton extends StatelessWidget {
  const PayButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.price,
  });
  final VoidCallback? onPressed;
  final String text;
  final int price;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: seconColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              '$price тг',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
