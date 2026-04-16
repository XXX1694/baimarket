import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';

class ProfilePhoneField extends StatefulWidget {
  const ProfilePhoneField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<ProfilePhoneField> createState() => _ProfilePhoneFieldState();
}

class _ProfilePhoneFieldState extends State<ProfilePhoneField> {
  final MaskTextInputFormatter _mask = MaskTextInputFormatter(
    mask: '(###) - ## - ##',
    filter: {'#': RegExp(r'\d')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.phoneNumber,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8A8A8A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: lightGray,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const _KzFlag(),
              const SizedBox(width: 8),
              const Text(
                '+7',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 22,
                width: 1,
                color: const Color(0xFFDADADA),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_mask],
                  autofillHints: const [AutofillHints.telephoneNumber],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    hintText: l10n.phoneNumberHint,
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFB5B5B5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KzFlag extends StatelessWidget {
  const _KzFlag();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF00AFCA),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.wb_sunny_rounded,
        size: 14,
        color: Color(0xFFFFD600),
      ),
    );
  }
}
