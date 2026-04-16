import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/services/share_service.dart';
import '../../../../core/urls.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileInviteBanner extends StatelessWidget {
  const ProfileInviteBanner({
    super.key,
    this.shareService = const ShareService(),
  });

  final ShareService shareService;

  Future<void> _onShare(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null && box.hasSize
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    try {
      await shareService.shareApp(
        message: l10n.shareAppMessage(shareAppUrl),
        sharePositionOrigin: origin,
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.shareAppError),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _onShare(context),
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/profile_page/profile_page_share_with_others.svg',
                width: 22,
                height: 22,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.inviteFriends,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: mainColorLight,
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
