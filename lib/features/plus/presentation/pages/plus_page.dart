import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../cards/data/models/payment_card_model.dart';
import '../../../cards/presentation/widgets/brand_logo.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';

const Color _kPlusPurple = Color(0xFF7479E5);

class PlusPage extends StatelessWidget {
  const PlusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _PlusHeader(),
              SizedBox(height: 14),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _IncludedCard(),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _BenefitsCard(),
              ),
              SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlusHeader extends StatelessWidget {
  const _PlusHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kPlusPurple,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 20,
      ),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final profile = state is ProfileGot ? state.profile : null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BackCircleButton(onPressed: () => context.pop()),
                    const Spacer(),
                    if (profile != null) _UserBadge(profile: profile),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _PlusWordmark(),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Вы в Плюсе',
                  style: TextStyle(
                    fontFamily: GoogleFonts.unbounded().fontFamily,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Доступно до 14 апреля. Далее включится Бай Plus',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _PaymentRow(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BackCircleButton extends StatelessWidget {
  const _BackCircleButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(40, 40),
      onPressed: onPressed,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _UserBadge extends StatelessWidget {
  const _UserBadge({required this.profile});
  final ProfileModel profile;

  String get _displayName {
    final first = (profile.firstName ?? '').trim();
    final last = (profile.lastName ?? '').trim();
    if (first.isEmpty && last.isEmpty) return 'Гость';
    if (last.isEmpty) return first;
    return '$first ${last[0]}';
  }

  String get _phone {
    final raw = (profile.phoneNumber ?? '').trim();
    if (raw.isEmpty) return '';
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && digits.startsWith('7'))
      return '8${digits.substring(1)}';
    if (digits.length == 10) return '8$digits';
    return digits;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _displayName,
          textAlign: TextAlign.end,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _phone,
          textAlign: TextAlign.end,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _PlusWordmark extends StatelessWidget {
  const _PlusWordmark();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SvgPicture.asset('assets/icons/Plus-NEW.svg', width: 110),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.push('/my_cards'),
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const BrandLogo(
                      brand: PaymentCardBrand.visa,
                      size: Size(56, 40),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Төлем картасы',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                          const Text(
                            '516949-XX-XXXX-2499',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.push('/plus/history'),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text(
                'История',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IncludedCard extends StatelessWidget {
  const _IncludedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Входит в вашу подписку',
        style: TextStyle(
          fontFamily: 'Gilroy',
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 4, bottom: 14),
            child: Text(
              'Ай сайынғы ұтыс!',
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          _BenefitTile(
            number: '1',
            title: 'Ақшалай\nсыйлықтар',
            gradient: LinearGradient(
              colors: [Color(0xFF9BD4F2), Color(0xFFC9E7F8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            trailingAsset: 'assets/images/prize1.png',
          ),
          SizedBox(height: 10),
          _BenefitTile(
            number: '2',
            title: 'Шетелге\nжолдама',
            gradient: LinearGradient(
              colors: [Color(0xFFA89DE6), Color(0xFFCDBEEC)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            trailingAsset: 'assets/images/prize2.png',
          ),
          SizedBox(height: 10),
          _BenefitTile(
            number: '3',
            title: 'Жаңа\nавтокөлік',
            gradient: LinearGradient(
              colors: [Color(0xFFE17676), Color(0xFFEC9D9D)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            trailingAsset: 'assets/images/prize3.png',
          ),
        ],
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({
    required this.number,
    required this.title,
    required this.gradient,
    required this.trailingAsset,
  });

  final String number;
  final String title;
  final LinearGradient gradient;
  final String trailingAsset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 62,
        decoration: BoxDecoration(gradient: gradient),
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.45),
                      ],
                    ).createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Text(
                  number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: GoogleFonts.unbounded().fontFamily,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: GoogleFonts.unbounded().fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.15,
                ),
              ),
            ),
            Image.asset(trailingAsset, width: 80, fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}
