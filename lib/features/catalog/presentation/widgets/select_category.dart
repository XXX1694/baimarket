import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/features/get_slug_list/presentation/cubit/slug_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/translation_utils.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key, required this.notifier});
  final ValueNotifier<String> notifier;
  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  final SlugCubit cubit = SlugCubit();
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SlugCubit, SlugState>(
      bloc: cubit,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SlugGot) {
          return SizedBox(
            height: 30,
            width: double.infinity,
            child: ListView.builder(
              itemCount: state.slugs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      widget.notifier.value = state.slugs[index].slug ?? 'all';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: EdgeInsets.only(
                      left: index == 0 ? 20 : 0,
                      right: index == state.slugs.length - 1 ? 20 : 0,
                    ),
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          selectedIndex == index
                              ? seconColor
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        TranslationUtils.getLocalizedDescription(
                          context: context,
                          descriptionKz: state.slugs[index].nameKz ?? '',
                          descriptionRu: state.slugs[index].nameRu ?? '',
                          descriptionEn: state.slugs[index].nameEn ?? '',
                        ),

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
