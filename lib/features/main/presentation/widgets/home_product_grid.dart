import 'package:flutter/material.dart';
import '../../../catalog/data/models/category_product_model.dart';
import 'home_product_card.dart';

class HomeProductGrid extends StatelessWidget {
  const HomeProductGrid({super.key, required this.products});
  final List<CategoryProductModel> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return HomeProductCard(product: products[index]);
      },
    );
  }
}
