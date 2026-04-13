import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/urls.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/banner_model.dart';

class BannerPage extends StatelessWidget {
  const BannerPage({super.key, required this.banner});
  final BannerModel banner;

  Future<void> _onContinue(BuildContext context) async {
    final link = banner.link;
    if (link == null || link.isEmpty) {
      context.pop();
      return;
    }

    final uri = Uri.tryParse(link);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      context.push(link);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = TranslationUtils.getLocalizedName(
      context: context,
      nameKz: banner.nameKz,
      nameRu: banner.nameRu,
      nameEn: banner.nameEn,
    );
    final description = TranslationUtils.getLocalizedDescription(
      context: context,
      descriptionKz: banner.descriptionKz,
      descriptionRu: banner.descriptionRu,
      descriptionEn: banner.descriptionEn,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Back button
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context.pop(),
                        child: SvgPicture.asset(
                          'assets/icons/arrow_left.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Banner image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: NetworkImageWidget(
                            url: '$imgUrl${banner.photoUrl ?? ''}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Title
                      if (title.isNotEmpty) ...[
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Description
                      if (description.isNotEmpty)
                        Text(
                          description,
                          style: const TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,

                          ),
                        ),

                    ],
                  ),
                ),
              ),

              // Continue button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: MainButton(
                  onPressed: () => _onContinue(context),
                  text: l10n.continueAction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
