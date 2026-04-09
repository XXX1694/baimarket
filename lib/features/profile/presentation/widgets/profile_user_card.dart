import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/urls.dart';
import '../../../../core/widgets/show_image.dart';
import '../../data/models/profile_model.dart';

class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard({super.key, required this.profile});
  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty;
    final displayName = profile.firstName != null && profile.firstName!.isNotEmpty
        ? '${profile.firstName} ${(profile.lastName ?? '').isNotEmpty ? profile.lastName![0].toUpperCase() + '.' : ''}'
        : 'User';
    final initial = profile.firstName != null && profile.firstName!.isNotEmpty
        ? profile.firstName![0].toUpperCase()
        : 'U';

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.push('/my_data', extra: profile),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: hasAvatar
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: NetworkImageWidget(url: '$imgUrl${profile.avatarUrl}'),
                    )
                  : Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: mainColorLight,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            // Name + phone
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    profile.phoneNumber ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/product_page/product_page_arrow_right.svg',
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
