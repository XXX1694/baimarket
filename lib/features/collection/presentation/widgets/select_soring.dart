import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io' show Platform;

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';
import '../pages/collection_page.dart';

List<String> sorting = ['popular', 'cheap', 'expensive'];

void showSortingSelectionModal(
  BuildContext context,
  TextEditingController controller,
  String slug,
) {
  final l10n = AppLocalizations.of(context)!;

  // Find current selected index based on controller text
  int selectedIndex = 0; // Default to first option
  if (controller.text == l10n.sortPopular) {
    selectedIndex = 0;
  } else if (controller.text == l10n.sortCheap) {
    selectedIndex = 1;
  } else if (controller.text == l10n.sortExpensive) {
    selectedIndex = 2;
  }

  Widget getPlatformRadio(int index) {
    final radio =
        Platform.isIOS
            ? CupertinoRadio<int>(value: index, activeColor: mainColorLight)
            : Radio<int>(value: index, activeColor: mainColorLight);

    return Transform.scale(scale: 1.2, child: radio);
  }

  String sortTextFor(int index) {
    switch (index) {
      case 0:
        return l10n.sortPopular;
      case 1:
        return l10n.sortCheap;
      case 2:
        return l10n.sortExpensive;
    }
    return '';
  }

  void applySort(BuildContext ctx, int index) {
    controller.text = sortTextFor(index);
    globalCollectionCubit.getCollection(slug: slug, sort: sorting[index]);
    Navigator.pop(ctx);
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    isScrollControlled: false,
    builder: (context) {
      return SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.showFirst,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: mainColorLight,
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/cancel.svg',
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: RadioGroup<int>(
                    groupValue: selectedIndex,
                    onChanged: (value) {
                      if (value == null) return;
                      applySort(context, value);
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: sorting.length,
                      itemBuilder: (context, index) {
                        final sortText = sortTextFor(index);

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          title: Text(
                            sortText,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.only(right: 8),
                            child: getPlatformRadio(index),
                          ),
                          onTap: () => applySort(context, index),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
    backgroundColor: Color(0xFFF7F7F7),
  );
}
