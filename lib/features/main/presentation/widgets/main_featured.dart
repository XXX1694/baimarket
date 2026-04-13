import 'package:bai_market/core/widgets/shimmer.dart';
import 'package:bai_market/features/get_slug_list/presentation/cubit/slug_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/urls.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/show_image.dart';

import '../../../get_slug_list/data/models/slug_model.dart';

class MainFeatured extends StatelessWidget {
  const MainFeatured({super.key});

  @override
  Widget build(BuildContext context) {
    late SlugCubit cubit = SlugCubit();
    List<SlugModel> slugs = [];
    return BlocConsumer<SlugCubit, SlugState>(
      listener: (context, state) {
        if (state is SlugGot) {
          slugs = state.slugs;
          slugs.removeAt(0);
        }
      },
      bloc: cubit,
      builder: (context, state) {
        if (state is SlugGot) {
          return SizedBox(
            height: 115,
            width: double.infinity,
            child: ListView.builder(
              itemCount: state.slugs.length,
              itemBuilder:
                  (context, index) => CupertinoButton(
                    onPressed: () {
                      context.push(
                        '/collection/${state.slugs[index].slug ?? 'new'}',
                      );
                    },
                    padding: EdgeInsets.only(
                      right: 8,
                      left: index == 0 ? 20 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            height: 85,
                            width: 85,

                            child: NetworkImageWidget(
                              url:
                                  state.slugs[index].iconUrl != null &&
                                          state.slugs[index].iconUrl!.isNotEmpty
                                      ? '$imgUrl${state.slugs[index].iconUrl!}'
                                      : '',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          TranslationUtils.getLocalizedDescription(
                            context: context,
                            descriptionKz:
                                state.slugs[index].nameKz ?? '',
                            descriptionRu:
                                state.slugs[index].nameRu ?? '',
                            descriptionEn:
                                state.slugs[index].nameEn ?? '',
                          ),

                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              scrollDirection: Axis.horizontal,
            ),
          );
        } else {
          return SizedBox(
            height: 115,
            width: double.infinity,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder:
                  (context, index) => CupertinoButton(
                    onPressed: () {},
                    padding: EdgeInsets.only(
                      right: 8,
                      left: index == 0 ? 20 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 85,
                          width: 85,
                          child: SimpleShimmer(borderRadius: 14),
                        ),

                        const SizedBox(height: 12),
                        Text(
                          'Название',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              scrollDirection: Axis.horizontal,
            ),
          );
        }
      },
    );
  }
}
