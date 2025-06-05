// ignore_for_file: deprecated_member_use

import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/features/cart/presentation/pages/cart_page.dart';
import 'package:bai_market/features/catalog/presentation/pages/catalog_page.dart';
import 'package:bai_market/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../main/presentation/pages/main_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.initialPage});
  final String initialPage;
  @override
  State<MenuPage> createState() => _MainScreenState();
}

class _MainScreenState extends State<MenuPage> {
  late StateProvider bottomNavIndexProvider;
  @override
  void initState() {
    switch (widget.initialPage) {
      case 'home':
        bottomNavIndexProvider = StateProvider((ref) => 0);
        break;
      case 'catalog':
        bottomNavIndexProvider = StateProvider((ref) => 1);
        break;
      case 'cart':
        bottomNavIndexProvider = StateProvider((ref) => 2);
        break;
      case 'profile':
        bottomNavIndexProvider = StateProvider((ref) => 3);
        break;
      default:
        bottomNavIndexProvider = StateProvider((ref) => 0);
        break;
    }
    super.initState();
  }

  Widget _buildNavItem({
    required Widget icon,
    required Widget activeIcon,
    required String label,
    required int index,
    required ref,
    required bool active,
  }) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        HapticFeedback.selectionClick();
        ref.read(bottomNavIndexProvider.notifier).update((state) => index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          active ? activeIcon : icon,
          const SizedBox(height: 3),
          Text(
            label,

            style:
                active
                    ? TextStyle(
                      fontWeight: FontWeight.w500,
                      color: mainColorLight,
                      fontSize: 11,
                      height: 16 / 11,
                    )
                    : TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontSize: 11,
                      height: 16 / 11,
                    ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final currentIndex = ref.watch(bottomNavIndexProvider);
          return IndexedStack(
            index: currentIndex,
            children: [
              MainPage(),
              CatalogPage(),
              CartPage(
                toCatalog: () {
                  ref
                      .read(bottomNavIndexProvider.notifier)
                      .update((state) => 1);
                },
              ),
              ProfilePage(),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final currentIndex = ref.watch(bottomNavIndexProvider);
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),

            decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.fromBorderSide(BorderSide(color: lightGray)),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Opacity(
                      opacity: 0.54,
                      child: SvgPicture.asset(
                        'assets/icons/home.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/home.svg',
                      color: mainColorLight,
                      height: 24,
                      width: 24,
                    ),
                    label: l10n.home,
                    index: 0,
                    ref: ref,
                    active: currentIndex == 0,
                  ),
                  _buildNavItem(
                    activeIcon: SvgPicture.asset(
                      'assets/icons/catalog.svg',
                      color: mainColorLight,
                      height: 24,
                      width: 24,
                    ),
                    icon: Opacity(
                      opacity: 0.54,
                      child: SvgPicture.asset(
                        'assets/icons/catalog.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    label: l10n.catalog,
                    index: 1,
                    ref: ref,
                    active: currentIndex == 1,
                  ),
                  _buildNavItem(
                    activeIcon: SvgPicture.asset(
                      'assets/icons/cart.svg',
                      color: mainColorLight,
                      height: 24,
                      width: 24,
                    ),
                    icon: Opacity(
                      opacity: 0.54,
                      child: SvgPicture.asset(
                        'assets/icons/cart.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    label: l10n.cart,
                    index: 2,
                    ref: ref,
                    active: currentIndex == 2,
                  ),
                  _buildNavItem(
                    activeIcon: SvgPicture.asset(
                      'assets/icons/profile.svg',
                      color: mainColorLight,
                      height: 24,
                      width: 24,
                    ),
                    icon: Opacity(
                      opacity: 0.54,
                      child: SvgPicture.asset(
                        'assets/icons/profile.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    label: l10n.profile,
                    index: 3,
                    ref: ref,
                    active: currentIndex == 3,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
