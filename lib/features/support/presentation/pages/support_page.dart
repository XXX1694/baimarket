import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';

const _phoneNumber = '77083453245';
const _phoneDisplay = '+7 708 345 32 45';
const _tgInvite = 'OJnsGK2O2SUyYTNi';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F4F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
              child: Row(
                children: [
                  Text(
                    l10n.contactsTitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 40),
                    onPressed: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4E4E4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Call center block
                    _SectionCard(
                      title: l10n.callCenter,
                      subtitle: l10n.callCenterSubtitle,
                      rows: [
                        _ContactRow(
                          iconAsset: 'assets/icons/contact/contact_phone.svg',
                          iconBg: const Color(0xFFBDF0D9),
                          title: _phoneDisplay,
                          subtitle: l10n.acceptCallsHours,
                          onTap: () => _call(),
                        ),
                        _ContactRow(
                          iconAsset: 'assets/icons/contact/contact_phone.svg',
                          iconBg: const Color(0xFFBDF0D9),
                          title: _phoneDisplay,
                          subtitle: l10n.acceptCallsHours,
                          onTap: () => _call(),
                        ),
                        _ContactRow(
                          iconAsset:
                              'assets/icons/contact/contact_whatsapp.svg',
                          iconBg: const Color(0xFFCFF4D9),
                          title: l10n.writeOnWhatsapp,
                          subtitle: l10n.respondHours,
                          onTap: () => _openWhatsApp(context),
                        ),
                        _ContactRow(
                          iconAsset:
                              'assets/icons/contact/contect_telegram.svg',
                          iconBg: const Color(0xFFCCE4FB),
                          title: l10n.writeOnTelegram,
                          subtitle: l10n.respondHours,
                          onTap: () => _openTelegram(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Delivery block
                    _SectionCard(
                      title: l10n.deliverySectionTitle,
                      subtitle: l10n.deliverySectionSubtitle,
                      rows: [
                        _ContactRow(
                          iconAsset:
                              'assets/icons/contact/contact_delivery.svg',
                          iconBg: const Color(0xFFFFC9C4),
                          title: l10n.deliverySectionTitle,
                          subtitle: l10n.respondHours,
                          onTap: () => _openTelegram(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Self-pickup block
                    _SectionCard(
                      title: l10n.selfPickupSectionTitle,
                      subtitle: l10n.deliverySectionSubtitle,
                      rows: [
                        _ContactRow(
                          iconAsset:
                              'assets/icons/contact/contect_brunch.svg',
                          iconBg: const Color(0xFFDFCFFD),
                          title: l10n.branches,
                          subtitle: l10n.respondHours,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: _phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final whatsappUri = Uri.parse('whatsapp://send?phone=$_phoneNumber');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      return;
    }
    final webUri = Uri.parse('https://wa.me/$_phoneNumber');
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openTelegram(BuildContext context) async {
    final tgUri = Uri.parse('tg://join?invite=$_tgInvite');
    if (await canLaunchUrl(tgUri)) {
      await launchUrl(tgUri, mode: LaunchMode.externalApplication);
      return;
    }
    final webUri = Uri.parse('https://t.me/+$_tgInvite');
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.rows,
  });
  final String title;
  final String subtitle;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9A9A9A),
              fontFamily: 'Gilroy',
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.iconAsset,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String iconAsset;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(iconAsset, width: 28, height: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA3A3A3),
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFB5B5B5),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
