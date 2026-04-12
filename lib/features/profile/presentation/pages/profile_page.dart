import 'package:bai_market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:bai_market/features/support/presentation/pages/support_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../widgets/profile_cart_banner.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_invite_banner.dart';
import '../widgets/profile_language_selector.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_user_card.dart';

ProfileCubit profileCubitGlobal = ProfileCubit();
final AuthCubit _authCubit = AuthCubit();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    profileCubitGlobal.getProfileData();
    globalCartCubit.getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubitGlobal,
      listener: (context, state) {
        if (state is ProfileGetError) {
          _authCubit.logOut();
          context.go('/');
        }
      },
      builder: (context, state) {
        if (state is ProfileGot) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header
                  const ProfileHeader(),
                  const SizedBox(height: 8),

                  // User Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ProfileUserCard(profile: state.profile),
                  ),
                  const SizedBox(height: 12),

                  // Cart Banner (shows when cart has items)
                  const ProfileCartBanner(),

                  // Menu Items block
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          svgAsset: 'assets/icons/profile_page/profile_page_tickets.svg',
                          title: l10n.myTickets,
                          subtitle: l10n.specifyDeliveryAddress,
                          onTap: () => context.push('/tickets'),
                          showDivider: true,
                        ),
                        ProfileMenuItem(
                          svgAsset: 'assets/icons/profile_page/profile_page_location.svg',
                          title: l10n.myAddresses,
                          subtitle: l10n.specifyDeliveryAddress,
                          onTap: () => context.push('/my_address'),
                          showDivider: true,
                        ),
                        ProfileMenuItem(
                          svgAsset: 'assets/icons/profile_page/profile_page_orders.svg',
                          title: l10n.myOrders,
                          subtitle: l10n.orderStatus,
                          onTap: () => context.push('/orders'),
                          showDivider: true,
                        ),
                        ProfileMenuItem(
                          svgAsset: 'assets/icons/profile_page/profile_page_card.svg',
                          title: l10n.myCard,
                          subtitle: l10n.orderStatus,
                          onTap: () {},
                          showDivider: true,
                        ),
                        ProfileMenuItem(
                          svgAsset: 'assets/icons/profile_page/profile_page_contacts.svg',
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
                        // Language Selector
                        const ProfileLanguageSelector(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Invite Friends
                  const ProfileInviteBanner(),
                  const SizedBox(height: 12),

                  // Logout Button
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
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
                                  await _authCubit.logOut();
                                  if (context.mounted) context.go('/');
                                },
                                child: Text(
                                  l10n.logout,
                                  style: const TextStyle(fontFamily: 'Gilroy'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              alignment: Alignment.center,
                              child: const Icon(
                                CupertinoIcons.square_arrow_left,
                                color: Color(0xFFE53935),
                                size: 22,
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
          );
        }
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
