import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.externalController,
    required this.onCodeComplete,
  });

  final TextEditingController externalController;
  final Function(String) onCodeComplete;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late FocusNode _focusNode;
  static const platform = MethodChannel('com.bai_market/sms');

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _setupSmsListener();
  }

  void _setupSmsListener() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onSmsReceived') {
        final String code = call.arguments as String;
        if (mounted) {
          setState(() {
            widget.externalController.text = code;
          });
          widget.onCodeComplete(code);
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Focus(
        focusNode: _focusNode,
        child: PinCodeTextField(
          appContext: context,
          length: 4,
          controller: widget.externalController,
          cursorColor: mainColorLight,
          cursorHeight: 22,
          cursorWidth: 1.5,
          textStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontFamily: 'Gilroy',
          ),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(14),
            fieldHeight: 60,
            fieldWidth: 58,
            fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 12),
            activeFillColor: const Color(0xFFEEEEEE),
            inactiveFillColor: const Color(0xFFEEEEEE),
            selectedFillColor: const Color(0xFFEEEEEE),
            activeColor: mainColorLight,
            inactiveColor: Colors.transparent,
            selectedColor: mainColorLight,
          ),
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          autoFocus: true,
          enablePinAutofill: true,
          mainAxisAlignment: MainAxisAlignment.center,
          pastedTextStyle: const TextStyle(),
          onChanged: (value) {},
          onCompleted: (value) {
            _focusNode.requestFocus();
            widget.onCodeComplete(value);
          },
          beforeTextPaste: (text) => true,
          autovalidateMode: AutovalidateMode.disabled,
          validator: (value) => null,
        ),
      ),
    );
  }
}
