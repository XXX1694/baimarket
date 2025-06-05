import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';

class MainButton extends StatelessWidget {
  const MainButton({super.key, required this.onPressed, required this.text});
  final VoidCallback? onPressed;
  final String text;
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
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: mainColorDark,
            ),
          ),
        ),
      ),
    );
  }
}
