import 'package:bai_market/features/support/presentation/widgets/faq_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    l10n.supportTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: mainColorLight,
                    ),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pop(context);
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
                          'assets/icons/cancel.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF575E6E),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.supportWorkingHours,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  _openWhatsApp(context);
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF33BB1B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/whatsapp.svg',
                          height: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.whatsapp,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  _openTelegram(context);
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF3D4DE1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/telegram.svg',
                          height: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.telegram,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.faq,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(child: FAQPage()),
            ],
          ),
        ),
      ),
    );
  }

  static const _inviteCode = 'OJnsGK2O2SUyYTNi';

  Future<void> _openTelegram(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    // 1) сначала пытаемся запустить сам Telegram
    final tgUri = Uri.parse('tg://join?invite=$_inviteCode');
    if (await canLaunchUrl(tgUri)) {
      await launchUrl(tgUri, mode: LaunchMode.externalApplication);
      return;
    }

    // 2) если Telegram не установлен — открываем ссылку в WebView
    final webUri = Uri.parse('https://t.me/+$_inviteCode');
    if (!await launchUrl(
      webUri,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    )) {
      throw l10n.failedToOpen(webUri.toString());
    }
  }

  static const _phoneNumber = '77002052728';

  Future<void> _openWhatsApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    // 1) Сначала пытаемся открыть нативный WhatsApp
    final whatsappUri = Uri.parse('whatsapp://send?phone=$_phoneNumber');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      return;
    }

    // 2) Если WhatsApp не установлен — открываем веб‑версию
    final webUri = Uri.parse('https://wa.me/$_phoneNumber');
    if (!await launchUrl(
      webUri,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    )) {
      throw l10n.failedToOpen(webUri.toString());
    }
  }
}
