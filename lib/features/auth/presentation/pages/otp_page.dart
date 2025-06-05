import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/core/widgets/main_button.dart';
import 'package:bai_market/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../widgets/otp_input.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key, required this.phoneNumber});
  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: _OtpPageContent(phoneNumber: phoneNumber),
    );
  }
}

class _OtpPageContent extends StatefulWidget {
  const _OtpPageContent({required this.phoneNumber});
  final String? phoneNumber;

  @override
  State<_OtpPageContent> createState() => _OtpPageContentState();
}

class _OtpPageContentState extends State<_OtpPageContent> {
  late TextEditingController controller;
  static const platform = MethodChannel('com.bai_market/sms');

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
    _listenToSmsCode();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _listenToSmsCode() async {
    try {
      await platform.invokeMethod('getSmsCode');
    } catch (e) {
      debugPrint('Error getting SMS code: $e');
    }
  }

  void _verifyOtp(String code) {
    if (code.length != 4) return;
    context.read<AuthCubit>().verifyOtp(
      phoneNumber: widget.phoneNumber ?? '',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is CodeVerified) {
                context.go('/main');
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
                  Text(
                    l10n.enterCode,
                    style: TextStyle(
                      fontSize: 22,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: mainColorLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.sentToNumber(widget.phoneNumber ?? ''),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  OtpInput(
                    externalController: controller,
                    onCodeComplete: _verifyOtp,
                  ),
                  const Spacer(),
                  MainButton(
                    onPressed: () {
                      _verifyOtp(controller.text);
                    },
                    text: l10n.signIn,
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
