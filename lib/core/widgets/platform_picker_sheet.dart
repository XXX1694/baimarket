import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_pallete.dart';

bool get _isIos => !kIsWeb && Platform.isIOS;

Future<T?> showPlatformItemPicker<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required String Function(T) itemLabel,
  T? selected,
  bool Function(T a, T b)? equals,
}) {
  if (_isIos) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (ctx) => _CupertinoPickerSheet<T>(
        title: title,
        items: items,
        itemLabel: itemLabel,
        selected: selected,
        equals: equals,
      ),
    );
  }
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: const Color(0xFFF7F7F7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (ctx) => _MaterialPickerSheet<T>(
      title: title,
      items: items,
      itemLabel: itemLabel,
      selected: selected,
      equals: equals,
    ),
  );
}

class _MaterialPickerSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemLabel;
  final T? selected;
  final bool Function(T a, T b)? equals;

  const _MaterialPickerSheet({
    required this.title,
    required this.items,
    required this.itemLabel,
    this.selected,
    this.equals,
  });

  bool _isSelected(T item) {
    if (selected == null) return false;
    return (equals ?? (a, b) => a == b)(item, selected as T);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: mainColorLight,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
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
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = _isSelected(item);
                    return ListTile(
                      title: Text(
                        itemLabel(item),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: mainColorLight)
                          : null,
                      onTap: () => Navigator.of(context).pop(item),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CupertinoPickerSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemLabel;
  final T? selected;
  final bool Function(T a, T b)? equals;

  const _CupertinoPickerSheet({
    required this.title,
    required this.items,
    required this.itemLabel,
    this.selected,
    this.equals,
  });

  bool _isSelected(T item) {
    if (selected == null) return false;
    return (equals ?? (a, b) => a == b)(item, selected as T);
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.secondaryLabel
                          .resolveFrom(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 0.5,
                  color: CupertinoColors.separator.resolveFrom(context),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Container(
                      height: 0.5,
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = _isSelected(item);
                      return CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        onPressed: () => Navigator.of(context).pop(item),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                itemLabel(item),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? mainColorLight
                                      : CupertinoColors.label
                                          .resolveFrom(context),
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                CupertinoIcons.check_mark,
                                size: 20,
                                color: mainColorLight,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(14),
            ),
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 14),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Отмена',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemRed.resolveFrom(context),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

Widget platformActivityIndicator({Color? color}) {
  return _isIos
      ? CupertinoActivityIndicator(color: color)
      : Center(child: CircularProgressIndicator(color: color));
}
