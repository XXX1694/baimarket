import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileInviteBanner extends StatelessWidget {
  const ProfileInviteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          // Invite friends action
        },
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                color: const Color(0xFF4ECDC4),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.inviteFriends,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4ECDC4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
