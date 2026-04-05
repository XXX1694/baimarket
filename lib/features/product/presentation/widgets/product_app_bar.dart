import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProductAppBar extends StatelessWidget {
  const ProductAppBar({
    super.key,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
              size: 26,
            ),
          ),
          const Spacer(),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              // Share functionality
            },
            child: const Icon(
              CupertinoIcons.share,
              color: Colors.black87,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onFavoriteTap,
            child: SvgPicture.asset(
              isFavorite ? 'assets/icons/liked.svg' : 'assets/icons/like_main.svg',
              height: 26,
              width: 26,
            ),
          ),
        ],
      ),
    );
  }
}
