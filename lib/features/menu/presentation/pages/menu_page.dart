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
import '../../../streams/presentation/pages/streams_page.dart';

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
        bottomNavIndexProvider = StateProvider((ref) => 2);
        break;
      case 'cart':
        bottomNavIndexProvider = StateProvider((ref) => 3);
        break;
      case 'profile':
        bottomNavIndexProvider = StateProvider((ref) => 4);
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
    required bool darkMode,
  }) {
    final activeColor = darkMode ? Colors.white : mainColorLight;
    final inactiveColor = darkMode ? Colors.white38 : Colors.black54;
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
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: active ? activeColor : inactiveColor,
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
              const StreamsPage(),
              CatalogPage(),
              CartPage(
                toCatalog: () {
                  ref
                      .read(bottomNavIndexProvider.notifier)
                      .update((state) => 2);
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
          final darkMode = currentIndex == 1;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: darkMode ? const Color(0xFF111111) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: darkMode ? Colors.white12 : Colors.black12,
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: SvgPicture.asset(
                      'assets/icons/main_menu/main_menu_baimarket_disabled.svg',
                      height: 24,
                      width: 24,
                      colorFilter: darkMode
                          ? const ColorFilter.mode(Colors.white38, BlendMode.srcIn)
                          : null,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/main_menu/main_menu_baimarket_active.svg',
                      height: 24,
                      width: 24,
                    ),
                    label: l10n.market,
                    index: 0,
                    ref: ref,
                    active: currentIndex == 0,
                    darkMode: darkMode,
                  ),
                  _buildNavItem(
                    icon: SvgPicture.asset(
                      'assets/icons/main_menu/main_menu_video_disabled.svg',
                      height: 24,
                      width: 24,
                      colorFilter: darkMode
                          ? const ColorFilter.mode(Colors.white38, BlendMode.srcIn)
                          : null,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/main_menu/main_menu_video_active.svg',
                      height: 24,
                      width: 24,
                      colorFilter: darkMode
                          ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : null,
                    ),
                    label: l10n.streams,
                    index: 1,
                    ref: ref,
                    active: currentIndex == 1,
                    darkMode: darkMode,
                  ),
                  _buildNavItem(
                    icon: SvgPicture.asset(
                      'assets/icons/main_menu/main_menu_catalog_disabled.svg',
                      height: 24,
                      width: 24,
                      colorFilter: darkMode
                          ? const ColorFilter.mode(Colors.white38, BlendMode.srcIn)
                          : null,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/main_menu/main_menu_catalog_active.svg',
                      height: 24,
                      width: 24,
                    ),
                    label: l10n.catalog,
                    index: 2,
                    ref: ref,
                    active: currentIndex == 2,
                    darkMode: darkMode,
                  ),
                  _buildNavItem(
                    icon: SvgPicture.asset(
                      'assets/icons/main_menu/main_menu_cart_disabled.svg',
                      height: 24,
                      width: 24,
                      colorFilter: darkMode
                          ? const ColorFilter.mode(Colors.white38, BlendMode.srcIn)
                          : null,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/main_menu/main_menu_cart_active.svg',
                      height: 24,
                      width: 24,
                    ),
                    label: l10n.cart,
                    index: 3,
                    ref: ref,
                    active: currentIndex == 3,
                    darkMode: darkMode,
                  ),
                  _buildNavItem(
                    icon: SvgPicture.asset(
                      'assets/icons/main_menu/main_menu_profile_disabled.svg',
                      height: 24,
                      width: 24,
                      colorFilter: darkMode
                          ? const ColorFilter.mode(Colors.white38, BlendMode.srcIn)
                          : null,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/main_menu/main_menu_profile_active.svg',
                      height: 24,
                      width: 24,
                    ),
                    label: l10n.profile,
                    index: 4,
                    ref: ref,
                    active: currentIndex == 4,
                    darkMode: darkMode,
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
