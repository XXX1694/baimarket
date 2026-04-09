import 'package:bai_market/features/collection/presentation/cubit/collection_cubit.dart';
import 'package:bai_market/features/main/presentation/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/shimmer.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_banner_carousel.dart';
import '../widgets/home_category_grid.dart';
import '../widgets/home_collection_tabs.dart';
import '../widgets/home_product_grid.dart';
import '../widgets/home_search_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainCubit _bannerCubit = MainCubit();
  final CollectionCubit _collectionCubit = CollectionCubit();

  @override
  void initState() {
    super.initState();
    _collectionCubit.getCollection(slug: 'all', sort: 'popular');
  }

  void _onTabChanged(String slug) {
    _collectionCubit.getCollection(slug: slug, sort: 'popular');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F7F7),
        body: Column(
          children: [
            const HomeAppBar(),
            Expanded(
              child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // Banner Carousel
            SliverToBoxAdapter(
              child: BlocBuilder<MainCubit, MainState>(
                bloc: _bannerCubit,
                builder: (context, state) {
                  if (state is BannerGot) {
                    return HomeBannerCarousel(banners: state.banners);
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 200,
                      child: SimpleShimmer(borderRadius: 20),
                    ),
                  );
                },
              ),
            ),

            // Search Bar
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: HomeSearchBar(),
              ),
            ),

            // Category Grid
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: HomeCategoryGrid(),
              ),
            ),

            // Collection Tabs
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: HomeCollectionTabs(onTabChanged: _onTabChanged),
              ),
            ),

            // Product Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 20),
                child: BlocBuilder<CollectionCubit, CollectionState>(
                  bloc: _collectionCubit,
                  builder: (context, state) {
                    if (state is CollectionGot) {
                      return HomeProductGrid(
                        products: state.collection.products,
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          return SimpleShimmer(borderRadius: 16);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
            ),
          ],
        ),
      ),
    );
  }
}
