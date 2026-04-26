import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../cubit/cart_cubit.dart';

class CartEventListener extends StatefulWidget {
  const CartEventListener({super.key, required this.child});

  final Widget child;

  @override
  State<CartEventListener> createState() => _CartEventListenerState();
}

class _CartEventListenerState extends State<CartEventListener> {
  StreamSubscription<CartEvent>? _sub;
  CartCubit? _cubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<CartCubit>();
    if (_cubit == cubit) return;
    _sub?.cancel();
    _cubit = cubit;
    _sub = cubit.events.listen(_handle);
  }

  void _handle(CartEvent event) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final String text;
    switch (event) {
      case CartAddFailedEvent():
        text = l10n.addToCartFailed;
        break;
      case CartRemoveFailedEvent():
        text = l10n.removeFromCartFailed;
        break;
      case CartAddUnauthenticatedEvent():
        text = l10n.loginRequired;
        break;
    }

    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            text,
            style: const TextStyle(fontFamily: 'Gilroy'),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
