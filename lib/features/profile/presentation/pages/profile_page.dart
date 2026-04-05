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
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header
                  const ProfileHeader(),
                  const SizedBox(height: 8),

                  // User Card
                  ProfileUserCard(profile: state.profile),
                  const SizedBox(height: 16),

                  // Cart Banner (shows when cart has items)
                  const ProfileCartBanner(),
                  const SizedBox(height: 8),

                  // Divider
                  Divider(
                    height: 1,
                    color: Colors.grey.shade100,
                    thickness: 8,
                  ),
                  const SizedBox(height: 8),

                  // Menu Items
                  ProfileMenuItem(
                    icon: CupertinoIcons.ticket,
                    iconColor: const Color(0xFFFF6B6B),
                    title: l10n.myTickets,
                    subtitle: l10n.specifyDeliveryAddress,
                    onTap: () => context.push('/tickets'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    iconColor: const Color(0xFF5B8DEF),
                    title: l10n.myAddresses,
                    subtitle: l10n.specifyDeliveryAddress,
                    onTap: () => context.push('/my_address'),
                  ),
                  ProfileMenuItem(
                    icon: CupertinoIcons.cart,
                    iconColor: const Color(0xFF4ECDC4),
                    title: l10n.myOrders,
                    subtitle: l10n.orderStatus,
                    onTap: () => context.push('/orders'),
                  ),
                  ProfileMenuItem(
                    icon: CupertinoIcons.creditcard,
                    iconColor: const Color(0xFF4ECDC4),
                    title: l10n.myCard,
                    subtitle: l10n.orderStatus,
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: CupertinoIcons.person_2,
                    iconColor: const Color(0xFF4ECDC4),
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
                  ),

                  // Language Selector
                  const ProfileLanguageSelector(),
                  const SizedBox(height: 16),

                  // Invite Friends
                  const ProfileInviteBanner(),
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
