import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/urls.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../get_slug_list/data/models/slug_model.dart';
import '../../../get_slug_list/presentation/cubit/slug_cubit.dart';

class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = SlugCubit();
    return BlocBuilder<SlugCubit, SlugState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is SlugGot) {
          final slugs = List<SlugModel>.from(state.slugs);
          if (slugs.isNotEmpty && slugs[0].slug == null) {
            slugs.removeAt(0);
          }
          return _buildGrid(context, slugs);
        }
        return _buildShimmerGrid();
      },
    );
  }

  Widget _buildGrid(BuildContext context, List<SlugModel> slugs) {
    final topRow = slugs.take(3).toList();
    final bottomRow = slugs.skip(3).take(2).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: topRow.map((slug) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: slug != topRow.last ? 8 : 0,
                  ),
                  child: _CategoryCard(slug: slug),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: bottomRow.map((slug) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: slug != bottomRow.last ? 8 : 0,
                  ),
                  child: _CategoryCard(slug: slug, height: 120),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  child: SizedBox(
                    height: 100,
                    child: SimpleShimmer(borderRadius: 16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              2,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 1 ? 8 : 0),
                  child: SizedBox(
                    height: 120,
                    child: SimpleShimmer(borderRadius: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.slug, this.height = 100});
  final SlugModel slug;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        context.push('/collection/${slug.slug ?? 'new'}');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              NetworkImageWidget(
                url: slug.iconUrl != null && slug.iconUrl!.isNotEmpty
                    ? '$imgUrl${slug.iconUrl!}'
                    : '',
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Text(
                  TranslationUtils.getLocalizedDescription(
                    context: context,
                    descriptionKz: slug.nameKz ?? '',
                    descriptionRu: slug.nameRu ?? '',
                    descriptionEn: slug.nameEn ?? '',
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
