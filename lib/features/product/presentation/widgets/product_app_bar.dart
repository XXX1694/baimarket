import 'package:flutter/cupertino.dart';
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
            child: SvgPicture.asset(
              'assets/icons/product_page/product_page_back_arrow.svg',
              height: 26,
              width: 26,
            ),
          ),
          const Spacer(),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: SvgPicture.asset(
              'assets/icons/product_page/product_page_share.svg',
              height: 26,
              width: 26,
            ),
          ),
          const SizedBox(width: 12),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onFavoriteTap,
            child: SvgPicture.asset(
              isFavorite
                  ? 'assets/icons/common/product_like_active.svg'
                  : 'assets/icons/product_page/product_page_like.svg',
              height: 26,
              width: 26,
            ),
          ),
        ],
      ),
    );
  }
}
