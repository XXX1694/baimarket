import 'package:bai_market/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../widgets/phone_number_input.dart';

const Color _teal = Color(0xFF3DBFAD);

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthCubit _cubit = AuthCubit();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _digits => _controller.text.replaceAll(RegExp(r'\D'), '');

  void _submit() {
    debugPrint('📱 controller.text = "${_controller.text}"');
    debugPrint('📱 digits = "$_digits"');
    if (_digits.isEmpty) {
      debugPrint('❌ digits empty, aborting');
      return;
    }
    debugPrint('🚀 calling sendOtp...');
    _cubit.sendOtp(phoneNumber: _digits);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: _cubit,
      listener: (context, state) {
        debugPrint('🔔 AuthState changed: ${state.runtimeType}');
        if (state is CodeSended) {
          debugPrint('✅ CodeSended → navigating to OTP');
          context.push('/auth/otp/$_digits');
        }
        if (state is AuthError) {
          debugPrint('❌ AuthError: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 82),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    l10n.phoneNumber,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Gilroy',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Text(
                    l10n.weWillSendSms,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                      fontFamily: 'Gilroy',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),

                // Phone input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: PhoneNumberInput(
                    controller: _controller,
                    onCountryChanged: (_) {},
                  ),
                ),

                const Spacer(),

                // Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    height: 60,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(8),
                      color: _teal,
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const CupertinoActivityIndicator(color: Colors.white)
                          : Text(
                              l10n.getCode,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Terms
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        fontFamily: 'Gilroy',
                      ),
                      children: [
                        TextSpan(text: l10n.termsAndPrivacy),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
