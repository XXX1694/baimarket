import 'package:flutter/material.dart';

import '../../data/models/payment_card_model.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.brand, this.size = const Size(56, 38)});
  final PaymentCardBrand brand;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      alignment: Alignment.center,
      child: brand == PaymentCardBrand.visa
          ? _VisaLogo(size: size)
          : const _MastercardLogo(),
    );
  }
}

class _VisaLogo extends StatelessWidget {
  const _VisaLogo({required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'VISA',
      style: TextStyle(
        fontSize: size.height * 0.42,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF1A1F71),
        fontStyle: FontStyle.italic,
        letterSpacing: -0.5,
        fontFamily: 'Gilroy',
      ),
    );
  }
}

class _MastercardLogo extends StatelessWidget {
  const _MastercardLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Color(0xFFEB001B),
            shape: BoxShape.circle,
          ),
        ),
        Transform.translate(
          offset: const Offset(-6, 0),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFFF79E1B).withAlpha(220),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
