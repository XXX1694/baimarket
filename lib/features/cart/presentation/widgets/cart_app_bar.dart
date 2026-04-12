import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../l10n/app_localizations.dart';

const Color _teal = Color(0xFF3DBFAD);

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
            padding: const EdgeInsets.all(8),
            onPressed: () => Navigator.of(context).maybePop(),
            child: SvgPicture.asset(
              'assets/icons/arrow_left.svg',
              width: 24,
              height: 24,
            ),
          ),
          Expanded(
            child: Text(
              l10n.cart,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'Gilroy',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (showClear)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onClear,
              child: Text(
                l10n.clearCart,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _teal,
                  fontFamily: 'Gilroy',
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
