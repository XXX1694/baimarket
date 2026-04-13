import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../get_slug_list/data/models/slug_model.dart';
import '../../../get_slug_list/presentation/cubit/slug_cubit.dart';

class CatalogTabs extends StatefulWidget {
  const CatalogTabs({super.key, required this.onTabChanged});
  final ValueChanged<String> onTabChanged;

  @override
  State<CatalogTabs> createState() => _CatalogTabsState();
}

class _CatalogTabsState extends State<CatalogTabs> {
  int _selectedIndex = 0;
  final SlugCubit _cubit = SlugCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlugCubit, SlugState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is SlugGot) {
          return _buildTabs(state.slugs);
        }
        return const SizedBox(height: 44);
      },
    );
  }

  Widget _buildTabs(List<SlugModel> slugs) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: slugs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          final name = TranslationUtils.getLocalizedDescription(
            context: context,
            descriptionKz: slugs[index].nameKz ?? '',
            descriptionRu: slugs[index].nameRu ?? '',
            descriptionEn: slugs[index].nameEn ?? '',
          );

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = index);
                widget.onTabChanged(slugs[index].slug ?? 'all');
              },
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? mainColorDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? null
                      : Border.all(color: Colors.black12, width: 0.5),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
