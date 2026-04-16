import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_pallete.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../data/models/raffle_model.dart';
import 'raffle_date_chip.dart';
import 'raffle_gifts_button.dart';

class RaffleDetailHeader extends StatelessWidget {
  const RaffleDetailHeader({
    super.key,
    required this.raffle,
    required this.onGiftsTap,
  });

  final RaffleModel raffle;
  final VoidCallback onGiftsTap;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final seller = raffle.seller;
    final title = seller == null
        ? ''
        : TranslationUtils.getLocalizedName(
            context: context,
            nameKz: seller.nameKz,
            nameRu: seller.nameRu,
            nameEn: seller.nameEn,
          );

    return Container(
      color: mainColorLight,
      padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BackButton(onTap: () => _pop(context)),
          const SizedBox(height: 28),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF5DDD3),
              height: 1.15,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Flexible(child: RaffleDateChip(iso: raffle.endDate)),
              const SizedBox(width: 10),
              RaffleGiftsButton(onTap: onGiftsTap),
            ],
          ),
        ],
      ),
    );
  }

  void _pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/catalog');
    }
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/arrow_left.svg',
            height: 20,
            width: 20,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
