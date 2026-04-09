import 'package:bai_market/features/collection/presentation/cubit/collection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/shimmer.dart';
import '../widgets/catalog_app_bar.dart';
import '../../../../core/widgets/product_card.dart';
import '../widgets/catalog_tabs.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final CollectionCubit _collectionCubit = CollectionCubit();

  @override
  void initState() {
    super.initState();
    _collectionCubit.getCollection(slug: 'new', sort: 'popular');
  }

  void _onTabChanged(String slug) {
    _collectionCubit.getCollection(slug: slug, sort: 'popular');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            const SliverToBoxAdapter(child: CatalogAppBar()),

            // Collection Tabs
            SliverToBoxAdapter(
              child: CatalogTabs(onTabChanged: _onTabChanged),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Product Grid
            SliverToBoxAdapter(
              child: BlocBuilder<CollectionCubit, CollectionState>(
                bloc: _collectionCubit,
                builder: (context, state) {
                  if (state is CollectionGot) {
                    final products = state.collection.products;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 320,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(product: products[index]);
                      },
                    );
                  }

                  // Shimmer loading
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.48,
                    ),
                    itemBuilder: (context, index) {
                      return SimpleShimmer(borderRadius: 16);
                    },
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
