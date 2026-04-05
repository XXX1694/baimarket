import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../get_slug_list/data/models/slug_model.dart';
import '../../../get_slug_list/presentation/cubit/slug_cubit.dart';

class HomeCollectionTabs extends StatefulWidget {
  const HomeCollectionTabs({super.key, required this.onTabChanged});
  final ValueChanged<String> onTabChanged;

  @override
  State<HomeCollectionTabs> createState() => _HomeCollectionTabsState();
}

class _HomeCollectionTabsState extends State<HomeCollectionTabs> {
  int _selectedIndex = 0;
  final SlugCubit _cubit = SlugCubit();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SlugCubit, SlugState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is SlugGot) {
          return _buildTabs(state.slugs, l10n);
        }
        return const SizedBox(height: 44);
      },
    );
  }

  Widget _buildTabs(List<SlugModel> slugs, AppLocalizations l10n) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: slugs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          final name = index == 0
              ? l10n.all
              : TranslationUtils.getLocalizedDescription(
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
                widget.onTabChanged(slugs[index].slug ?? 'new');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
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
