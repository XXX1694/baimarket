import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';

class PlusPriceBadge extends StatelessWidget {
  const PlusPriceBadge({super.key, required this.plusPrice});
  final int plusPrice;

  static const _gradient = LinearGradient(
    colors: [Color(0xFF117DAA), Color(0xFF1EA396)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _gradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FEFE),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/main_plus.svg',
                height: 22,
                width: 22,
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 52,
                child: _gradientText(
                  l10n.plusPrice,
                  const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy',
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          _gradientText(
            l10n.price(plusPrice.toString()),
            TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
