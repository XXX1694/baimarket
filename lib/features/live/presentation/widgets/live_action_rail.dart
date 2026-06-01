import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Вертикальный ряд action-кнопок справа на лайв-странице (как TikTok):
/// корзина, чат, лайк. Каждая — иконка + число под ней.
class LiveActionRail extends StatelessWidget {
  const LiveActionRail({
    super.key,
    required this.cartCount,
    required this.messageCount,
    required this.likesCount,
    this.onCartTap,
    this.onMessageTap,
    this.onLikeTap,
  });

  final int cartCount;
  final int messageCount;
  final int likesCount;
  final VoidCallback? onCartTap;
  final VoidCallback? onMessageTap;
  final VoidCallback? onLikeTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RailItem(
            asset: 'assets/icons/stream/action_bag.svg',
            count: cartCount,
            onTap: onCartTap,
          ),
          const SizedBox(height: 10),
          _RailItem(
            asset: 'assets/icons/stream/action_message.svg',
            count: messageCount,
            onTap: onMessageTap,
          ),
          const SizedBox(height: 10),
          _RailItem(
            asset: 'assets/icons/stream/action_heart.svg',
            count: likesCount,
            onTap: onLikeTap,
          ),
        ],
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({required this.asset, required this.count, this.onTap});
  final String asset;
  final int count;
  final VoidCallback? onTap;

  String _fmt(int v) {
    if (v >= 1000) {
      final k = (v / 1000);
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    }
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(40, 56),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(asset, width: 40, height: 40),
          const SizedBox(height: 2),
          Text(
            _fmt(count),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 0.22,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
