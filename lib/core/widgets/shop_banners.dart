import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Три баннера-магазина (`assets/images/shopN.png`) — стопкой.
/// Каждый тапается и открывает `/shop` с соответствующим `titleOverride`.
///
/// Используется в каталоге (вкладка «Все магазины») вместо placeholder-плиток.
class ShopBanners extends StatelessWidget {
  const ShopBanners({super.key, this.padding = EdgeInsets.zero});
  final EdgeInsets padding;

  static const _items = <_ShopBanner>[
    _ShopBanner(
      asset: 'assets/images/shop1.png',
      title: 'Ырысбала\nИкрамбай',
    ),
    _ShopBanner(
      asset: 'assets/images/shop2.png',
      title: 'Әбдіжаппар\nӘлқожа',
    ),
    _ShopBanner(
      asset: 'assets/images/shop3.png',
      title: 'Төреғали\nТөреәлі',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          for (int i = 0; i < _items.length; i++) ...[
            if (i != 0) const SizedBox(height: 12),
            _ShopBannerCard(item: _items[i]),
          ],
        ],
      ),
    );
  }
}

class _ShopBanner {
  final String asset;
  final String title;
  const _ShopBanner({required this.asset, required this.title});
}

class _ShopBannerCard extends StatelessWidget {
  const _ShopBannerCard({required this.item});
  final _ShopBanner item;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.push('/shop', extra: {'title': item.title}),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 136,
          width: double.infinity,
          child: Image.asset(
            item.asset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF1E1E1E),
              alignment: Alignment.center,
              child: const Icon(
                Icons.broken_image_outlined,
                color: Colors.white24,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
