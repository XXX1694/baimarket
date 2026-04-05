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
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
            padding: const EdgeInsets.only(right: 8),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() => _selectedIndex = index);
                widget.onTabChanged(slugs[index].slug ?? 'all');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4ECDC4) : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF4ECDC4)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black87,
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
