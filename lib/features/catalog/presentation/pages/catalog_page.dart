import 'package:bai_market/features/collection/presentation/cubit/collection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../raffle/presentation/cubit/raffle_list_cubit.dart';
import '../../../raffle/presentation/widgets/raffles_list_view.dart';
import '../widgets/catalog_app_bar.dart';
import '../widgets/catalog_tabs.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final CollectionCubit _collectionCubit = CollectionCubit();
  final RaffleListCubit _raffleListCubit = RaffleListCubit();
  String _currentSlug = raffleTabSlug;

  @override
  void initState() {
    super.initState();
    _raffleListCubit.load();
  }

  @override
  void dispose() {
    _collectionCubit.close();
    _raffleListCubit.close();
    super.dispose();
  }

  void _onTabChanged(String slug) {
    if (slug == _currentSlug) return;
    setState(() => _currentSlug = slug);
    if (slug == raffleTabSlug) {
      if (_raffleListCubit.state is RaffleListInitial ||
          _raffleListCubit.state is RaffleListError) {
        _raffleListCubit.load();
      }
    } else {
      _collectionCubit.getCollection(slug: slug, sort: 'popular');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: BlocProvider.value(
          value: _raffleListCubit,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: CatalogAppBar()),
              SliverToBoxAdapter(
                child: CatalogTabs(
                  onTabChanged: _onTabChanged,
                  rafflesLabel: l10n.raffleTab,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(child: _body()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    final Widget child;
    if (_currentSlug == raffleTabSlug) {
      child = const KeyedSubtree(
        key: ValueKey(raffleTabSlug),
        child: RafflesListView(),
      );
    } else {
      child = KeyedSubtree(
        key: ValueKey(_currentSlug),
        child: _CollectionGrid(cubit: _collectionCubit, slug: _currentSlug),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: child,
    );
  }
}

class _CollectionGrid extends StatelessWidget {
  const _CollectionGrid({required this.cubit, required this.slug});

  final CollectionCubit cubit;
  final String slug;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionCubit, CollectionState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is CollectionGot) {
          final products = state.collection.products;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 320,
            ),
            itemBuilder: (_, i) => ProductCard(product: products[i]),
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.48,
          ),
          itemBuilder: (_, __) => const SimpleShimmer(borderRadius: 16),
        );
      },
    );
  }
}
