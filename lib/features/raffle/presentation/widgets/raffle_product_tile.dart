import 'package:flutter/material.dart';

import '../../../../core/widgets/product_card.dart';
import '../../../catalog/data/models/category_product_model.dart';
import '../../data/datasources/raffle_mock.dart';

/// Wraps [ProductCard] with a demo overlay when the product is mock data.
/// Mock products cannot be opened, added to cart, or favorited — the real
/// API would 404 on their negative ids.
class RaffleProductTile extends StatelessWidget {
  const RaffleProductTile({super.key, required this.product});

  final CategoryProductModel product;

  bool get _isDemo => RaffleMock.isMockId(product.id);

  @override
  Widget build(BuildContext context) {
    final card = ProductCard(product: product);
    if (!_isDemo) return card;

    return Stack(
      children: [
        AbsorbPointer(child: card),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showDemoSnack(context),
            child: const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  void _showDemoSnack(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Демо-товар. Будет доступен, когда админ добавит реальные розыгрыши.',
            style: TextStyle(fontFamily: 'Gilroy'),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
