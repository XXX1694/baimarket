import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_pallete.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key, required this.controller});
  final TextEditingController controller;
  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  final String _countryCode = '+7';
  final int _maxPhoneLength = 10;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CountryCodePrefix(countryCode: _countryCode),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: lightGray,
                ),
                padding: const EdgeInsets.only(left: 16),
                child: TextField(
                  cursorColor: mainColorLight,
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_maxPhoneLength),
                    PhoneNumberFormatter(),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusColor: mainColorLight,
                    hintText: 'XXX XXX XX XX',
                    hintStyle: TextStyle(color: Colors.black45),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                    color: mainColorLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryCodePrefix extends StatelessWidget {
  final String countryCode;

  const _CountryCodePrefix({required this.countryCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: lightGray,
      ),
      padding: const EdgeInsets.only(top: 13),
      child: Text(
        countryCode,
        style: const TextStyle(
          fontSize: 22,
          color: mainColorLight,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (newText.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if (i == 3 || i == 6 || i == 8) {
        buffer.write(' ');
      }
      buffer.write(newText[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class PhoneNumberValidator {
  static bool isValidPhoneNumber(String phoneNumber) {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    return cleanedNumber.length == 10; // Проверка на длину номера
  }
}
