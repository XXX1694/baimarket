import 'dart:io';

import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/core/providers/language_provider.dart';
import 'package:bai_market/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bai_market/features/support/presentation/pages/support_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;

import '../../../../l10n/app_localizations.dart';

final AuthCubit authCubit = AuthCubit();

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = provider.Provider.of<LanguageProvider>(context);

    return Column(
      children: [
        // CupertinoButton(
        //   padding: const EdgeInsets.all(0),
        //   onPressed: () {
        //     context.push('/my_data');
        //   },
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 10),
        //     margin: const EdgeInsets.only(bottom: 12),
        //     height: 60,
        //     width: double.infinity,
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(16),
        //     ),
        //     child: Row(
        //       children: [
        //         Container(
        //           height: 40,
        //           width: 40,
        //           decoration: BoxDecoration(
        //             color: seconColor,
        //             borderRadius: BorderRadius.circular(12),
        //           ),
        //           child: Center(
        //             child: SvgPicture.asset('assets/icons/green_bell.svg'),
        //           ),
        //         ),
        //         const SizedBox(width: 12),
        //         Text(
        //           'Мои данные',
        //           style: TextStyle(
        //             fontSize: 16,
        //             fontWeight: FontWeight.w500,
        //             color: Colors.black,
        //           ),
        //         ),
        //         const Spacer(),
        //         SvgPicture.asset('assets/icons/arrow_right.svg'),
        //       ],
        //     ),
        //   ),
        // ),
        CupertinoButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            context.push('/my_address');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(bottom: 12),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: seconColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset('assets/icons/green_building.svg'),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.myAddresses,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                SvgPicture.asset('assets/icons/arrow_right.svg'),
              ],
            ),
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            context.push('/orders');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(bottom: 12),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: seconColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset('assets/icons/green_ticket.svg'),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.orderHistory,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                SvgPicture.asset('assets/icons/arrow_right.svg'),
              ],
            ),
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            showModalBottomSheet(
              elevation: 0,
              backgroundColor: Colors.white,
              isScrollControlled: true,
              useSafeArea: true,
              context: context,
              builder: (context) => const SupportPage(),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(bottom: 12),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: seconColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/green_headphones.svg',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.support,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                SvgPicture.asset('assets/icons/arrow_right.svg'),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(bottom: 12),
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: seconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset('assets/icons/green_globe.svg'),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.language,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  languageProvider.changeLanguage('kk');
                },
                child: Container(
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color:
                        languageProvider.currentLocale.languageCode == 'kk'
                            ? seconColor
                            : const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Қазақша',
                      style: TextStyle(
                        color:
                            languageProvider.currentLocale.languageCode == 'kk'
                                ? Colors.black
                                : Colors.black,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  languageProvider.changeLanguage('ru');
                },
                child: Container(
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color:
                        languageProvider.currentLocale.languageCode == 'ru'
                            ? seconColor
                            : const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Русский',
                      style: TextStyle(
                        color:
                            languageProvider.currentLocale.languageCode == 'ru'
                                ? Colors.black
                                : Colors.black,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            _showExitConfirmationDialog(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(bottom: 12),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF73030),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/exit.svg',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.logout,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    if (Platform.isAndroid) {
      _showAndroidExitDialog(context);
    } else if (Platform.isIOS) {
      _showIOSExitDialog(context);
    }
  }

  void _showAndroidExitDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.exitApp),
          content: Text(l10n.exitConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                authCubit.logOut();
                context.go('/auth');
              },
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }

  void _showIOSExitDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(l10n.exitApp),
          content: Text(l10n.exitConfirmation),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
              child: Text(l10n.cancel),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                authCubit.logOut();
                context.go('/auth');
              },
              isDestructiveAction: true,
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }
}
