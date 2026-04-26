import 'package:bai_market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:bai_market/features/support/presentation/pages/support_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/sign_out.dart';
import '../../../../core/widgets/app_refresh_indicator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../widgets/profile_cart_banner.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_invite_banner.dart';
import '../widgets/profile_language_selector.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_user_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileCubit>().getProfileData();
      context.read<CartCubit>().getCart();
    });
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<ProfileCubit>().getProfileData(),
      context.read<CartCubit>().getCart(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileGetError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.error(''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().getProfileData(),
                      child: Text(
                        l10n.confirm,
                        style: const TextStyle(fontFamily: 'Gilroy'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is ProfileGot) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: AppRefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ProfileUserCard(profile: state.profile),
                  ),
                  const SizedBox(height: 12),
                  const ProfileCartBanner(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          svgAsset: 'assets/icons/like.svg',
                          title: l10n.favorites,
                          subtitle:
                              '${state.profile.favoritesCount ?? 0} ${l10n.products}',
                          onTap: () => context.push('/favorites'),
                          showDivider: true,
                        ),
                        ProfileMenuItem(
                          svgAsset:
                              'assets/icons/profile_page/profile_page_tickets.svg',
                          title: l10n.myTickets,
                          subtitle: l10n.specifyDeliveryAddress,
                          onTap: () => context.push('/tickets'),
                          showDivider: true,
                        ),
                        ProfileMenuItem(
                          svgAsset:
                              'assets/icons/profile_page/profile_page_location.svg',
                          title: l10n.myAddresses,
                          subtitle: l10n.specifyDeliveryAddress,
                          onTap: () => context.push('/my_address'),
                          showDivider: true,
                        ),
                        ProfileMenuItem(
                          svgAsset:
                              'assets/icons/profile_page/profile_page_orders.svg',
                          title: l10n.myOrders,
                          subtitle: l10n.orderStatus,
                          onTap: () => context.push('/orders'),
                          showDivider: true,
                        ),
                        ProfileMenuItem(
                          svgAsset:
                              'assets/icons/profile_page/profile_page_card.svg',
                          title: l10n.myCard,
                          subtitle: l10n.orderStatus,
                          onTap: () => context.push('/my_cards'),
                          showDivider: true,
                        ),
                        ProfileMenuItem(
                          svgAsset:
                              'assets/icons/profile_page/profile_page_contacts.svg',
                          title: l10n.contacts,
                          subtitle: l10n.orderStatus,
                          onTap: () {
                            showModalBottomSheet(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (_) => const SupportPage(),
                            );
                          },
                          showDivider: true,
                        ),
                        const ProfileLanguageSelector(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const ProfileInviteBanner(),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _confirmLogout(context, l10n),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 26,
                              height: 26,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/arrow_left.svg',
                                  width: 22,
                                  height: 22,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFE53935),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              l10n.logout,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFE53935),
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              ),
            ),
          );
        }
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context, AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(
          l10n.exitApp,
          style: const TextStyle(fontFamily: 'Gilroy'),
        ),
        content: Text(
          l10n.exitConfirmation,
          style: const TextStyle(fontFamily: 'Gilroy'),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.cancel,
              style: const TextStyle(fontFamily: 'Gilroy'),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.of(ctx).pop();
              await signOutAndCleanup(context);
            },
            child: Text(
              l10n.logout,
              style: const TextStyle(fontFamily: 'Gilroy'),
            ),
          ),
        ],
      ),
    );
  }
}
