import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../collection/presentation/cubit/collection_cubit.dart';
import '../../../main/presentation/widgets/home_product_card.dart';

class CartRecommended extends StatefulWidget {
  const CartRecommended({super.key});

  @override
  State<CartRecommended> createState() => _CartRecommendedState();
}

class _CartRecommendedState extends State<CartRecommended> {
  final CollectionCubit _cubit = CollectionCubit();

  @override
  void initState() {
    super.initState();
    _cubit.getCollection(slug: 'new', sort: 'popular');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<CollectionCubit, CollectionState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is CollectionGot && state.collection.products.isNotEmpty) {
          final products = state.collection.products;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.recommended,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: products.length > 8 ? 8 : products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 170,
                      margin: const EdgeInsets.only(right: 10),
                      child: HomeProductCard(product: products[index]),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
