import 'package:bai_market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_pallete.dart';
import '../../../../core/urls.dart';
import '../../../../core/widgets/show_image.dart';
import '../widgets/menu_list.dart';
import '../widgets/my_tickets.dart';
import '../widgets/profile_list.dart';

ProfileCubit profileCubitGlobal = ProfileCubit();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    profileCubitGlobal.getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubitGlobal,
      listener: (context, state) {
        if (state is ProfileGetError) {
          authCubit.logOut();
          context.go('/');
        }
      },
      builder: (context, state) {
        if (state is ProfileGot) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              'Профиль',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: mainColorLight,
                              ),
                            ),
                            const Spacer(),
                            CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                context.push('/notification');
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
                                    'assets/icons/ring.svg',
                                    color: Color(0xFF575E6E),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: lightGray,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child:
                                  state.profile.avatarUrl != null &&
                                          state.profile.avatarUrl!.isNotEmpty
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: NetworkImageWidget(
                                          url:
                                              '$imgUrl${state.profile.avatarUrl}',
                                        ),
                                      )
                                      : Center(
                                        child: Text(
                                          state.profile.firstName!.isNotEmpty
                                              ? '${(state.profile.firstName ?? 'U')[0]}${(state.profile.lastName ?? 'S')[0]}'
                                              : 'U',
                                          style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.profile.firstName!.isNotEmpty
                                      ? '${state.profile.firstName} ${state.profile.lastName?[0]}.'
                                      : "Профиль",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '+7${state.profile.phoneNumber}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                context.push('/my_data', extra: state.profile);
                              },
                              child: SvgPicture.asset(
                                'assets/icons/arrow_right.svg',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  MenuList(profile: state.profile),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: lightGray,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              MyTickets(),
                              const SizedBox(height: 12),
                              ProfileList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }
}
