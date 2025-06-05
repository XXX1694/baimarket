import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class OrderAgainButton extends StatelessWidget {
  const OrderAgainButton({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        context.push('/payment', extra: url);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Center(
          child: Text('Перейти в оплате', style: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }
}
