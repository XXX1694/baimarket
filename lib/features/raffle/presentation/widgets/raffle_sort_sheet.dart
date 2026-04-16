import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';

/// Keep in sync with the backend enum (see MOBILE_API_CHANGES.md).
const raffleSortOptions = <String>['popular', 'cheap', 'expensive', 'discount'];

String raffleSortLabel(AppLocalizations l10n, String sort) {
  switch (sort) {
    case 'cheap':
      return l10n.sortCheap;
    case 'expensive':
      return l10n.sortExpensive;
    case 'discount':
      return l10n.sortDiscount;
    case 'popular':
    default:
      return l10n.sortPopular;
  }
}

Future<String?> showRaffleSortSheet({
  required BuildContext context,
  required String current,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: const Color(0xFFF7F7F7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (_) => _RaffleSortSheet(current: current),
  );
}

class _RaffleSortSheet extends StatelessWidget {
  const _RaffleSortSheet({required this.current});

  final String current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      fontFamily: 'Gilroy',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: mainColorLight,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/cancel.svg',
                          height: 22,
                          width: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: raffleSortOptions.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Color(0xFFEFEFEF),
                  indent: 20,
                  endIndent: 20,
                ),
                itemBuilder: (_, i) {
                  final option = raffleSortOptions[i];
                  final selected = option == current;
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(
                      raffleSortLabel(l10n, option),
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    trailing: _PlatformRadio(selected: selected),
                    onTap: () => Navigator.pop(context, option),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlatformRadio extends StatelessWidget {
  const _PlatformRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final radio = Platform.isIOS
        ? CupertinoRadio<bool>(
            value: true,
            groupValue: selected ? true : null,
            activeColor: mainColorLight,
            onChanged: (_) {},
          )
        : Radio<bool>(
            value: true,
            groupValue: selected ? true : null,
            activeColor: mainColorLight,
            onChanged: (_) {},
          );
    return IgnorePointer(child: Transform.scale(scale: 1.15, child: radio));
  }
}
