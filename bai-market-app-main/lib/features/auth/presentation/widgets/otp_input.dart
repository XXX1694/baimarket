import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/app_pallete.dart';

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
    return SizedBox(
      width: 270,
      child: Focus(
        focusNode: _focusNode,
        child: PinCodeTextField(
          appContext: context,
          length: 4,
          controller: widget.externalController,
          cursorColor: mainColorLight,
          textStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: mainColorLight,
          ),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 60,
            fieldWidth: 60,
            activeFillColor: lightGray,
            inactiveFillColor: lightGray,
            selectedFillColor: lightGray,
            activeColor: mainColorLight,
            inactiveColor: Colors.transparent,
            selectedColor: mainColorLight,
          ),
          enableActiveFill: true,
          keyboardType: TextInputType.number,

          autoFocus: true,
          cursorHeight: 0,
          enablePinAutofill: true,
          onChanged: (value) {},
          onCompleted: (value) {
            _focusNode.requestFocus();
            widget.onCodeComplete(value);
          },
          beforeTextPaste: (text) {
            return true;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value?.length != 4) {
              return '';
            }
            return null;
          },
        ),
      ),
    );
  }
}
