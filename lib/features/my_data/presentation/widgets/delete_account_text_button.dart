import 'package:flutter/cupertino.dart';

class DeleteAccountTextButton extends StatelessWidget {
  const DeleteAccountTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF8A8A8A),
        ),
      ),
    );
  }
}
