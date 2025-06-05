import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({
    super.key,
    required this.onPressed,
    required this.text,
  });
  final VoidCallback? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF73030),
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
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
