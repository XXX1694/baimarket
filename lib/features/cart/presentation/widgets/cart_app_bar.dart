import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key, this.onClear, this.showClear = false});
  final VoidCallback? onClear;
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 16,
        bottom: 8,
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
              size: 26,
            ),
          ),
          const Expanded(
            child: Text(
              '',
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            l10n.cart,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const Expanded(child: SizedBox()),
          if (showClear)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onClear,
              child: Text(
                l10n.clearCart,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: mainColorLight,
                ),
              ),
            )
          else
            const SizedBox(width: 60),
        ],
      ),
    );
  }
}
