import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_pallete.dart';
import '../../../../core/urls.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/raffle_model.dart';
import '../utils/raffle_date_formatter.dart';

class RaffleCard extends StatelessWidget {
  const RaffleCard({super.key, required this.raffle});

  final RaffleModel raffle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final seller = raffle.seller;
    final title = seller == null
        ? l10n.raffleDefaultTitle
        : TranslationUtils.getLocalizedName(
            context: context,
            nameKz: seller.nameKz,
            nameRu: seller.nameRu,
            nameEn: seller.nameEn,
          );
    final coverUrl = raffle.gifts.isNotEmpty
        ? raffle.gifts.first.photoUrl
        : null;

    final drawDate = RaffleDateFormatter.formatDrawDate(
      context: context,
      iso: raffle.endDate,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/raffle/${raffle.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Cover(url: coverUrl),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (drawDate.isNotEmpty)
                    _MetaChip(
                      label: l10n.raffleDateLabel(drawDate),
                    ),
                  if (raffle.gifts.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.raffleGiftsCount(raffle.gifts.length),
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/arrow_right.svg',
              height: 18,
              width: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final fullUrl = (url == null || url!.isEmpty) ? '' : '$imgUrl$url';
    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        color: lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: fullUrl.isEmpty
          ? const Icon(
              Icons.card_giftcard_rounded,
              size: 32,
              color: mainColorLight,
            )
          : NetworkImageWidget(url: fullUrl, fit: BoxFit.cover),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: mainColorLight.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Gilroy',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: mainColorDark,
        ),
      ),
    );
  }
}
