import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        ? '${profile.firstName} ${(profile.lastName ?? '')[0].toUpperCase()}'
        : 'User';
    final initial = profile.firstName != null && profile.firstName!.isNotEmpty
        ? profile.firstName![0].toUpperCase()
        : 'U';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => context.push('/my_data', extra: profile),
        child: Row(
          children: [
            // Avatar
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: hasAvatar
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: NetworkImageWidget(url: '$imgUrl${profile.avatarUrl}'),
                    )
                  : Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4ECDC4),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    profile.phoneNumber ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
