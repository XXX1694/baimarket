import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({
    super.key,
    required this.controller,
    required this.onCountryChanged,
  });

  final TextEditingController controller;
  final void Function(String dialCode) onCountryChanged;

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  final MaskTextInputFormatter _maskFormatter = MaskTextInputFormatter(
    mask: '(###) ### ## ##',
    filter: {'#': RegExp(r'\d')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntlPhoneField(
        controller: widget.controller,
        initialCountryCode: 'KZ',
        keyboardType: TextInputType.phone,
        cursorColor: Colors.black54,
        autovalidateMode: AutovalidateMode.disabled,
        showDropdownIcon: false,
        flagsButtonPadding: const EdgeInsets.only(right: 10),
        inputFormatters: [_maskFormatter],
        disableLengthCheck: true,
        invalidNumberMessage: null,
        dropdownTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontFamily: 'Gilroy',
        ),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontFamily: 'Gilroy',
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: '(000) 000 00 00',
          hintStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black26,
            fontFamily: 'Gilroy',
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 18),
          counterText: '',
        ),
        onCountryChanged: (country) {
          widget.onCountryChanged(country.dialCode);
        },
        onChanged: (_) {},
      ),
    );
  }
}
