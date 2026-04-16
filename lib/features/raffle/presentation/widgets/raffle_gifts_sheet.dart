import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/app_pallete.dart';
import '../../../../core/urls.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/gift_model.dart';

void showRaffleGiftsSheet({
  required BuildContext context,
  required List<GiftModel> gifts,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFF7F7F7),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (_) => _RaffleGiftsSheet(gifts: gifts),
  );
}

class _RaffleGiftsSheet extends StatelessWidget {
  const _RaffleGiftsSheet({required this.gifts});

  final List<GiftModel> gifts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.raffleGiftsTitle,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: mainColorLight,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/cancel.svg',
                          height: 22,
                          width: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (gifts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.raffleGiftsEmpty,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  shrinkWrap: true,
                  itemCount: gifts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _GiftTile(gift: gifts[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GiftTile extends StatelessWidget {
  const _GiftTile({required this.gift});

  final GiftModel gift;

  @override
  Widget build(BuildContext context) {
    final fullUrl =
        (gift.photoUrl == null || gift.photoUrl!.isEmpty)
            ? ''
            : '$imgUrl${gift.photoUrl}';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: fullUrl.isEmpty
                ? const Icon(
                    Icons.card_giftcard_rounded,
                    color: mainColorLight,
                  )
                : NetworkImageWidget(url: fullUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              gift.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
