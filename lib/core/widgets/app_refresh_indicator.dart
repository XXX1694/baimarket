import 'package:flutter/material.dart';

import '../app_pallete.dart';
import '../../l10n/app_localizations.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.dark = false,
    this.edgeOffset = 0,
    this.displacement = 28,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final bool dark;
  final double edgeOffset;
  final double displacement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: dark ? Colors.white : mainColorLight,
      backgroundColor: dark ? const Color(0xFF1A1A1A) : Colors.white,
      strokeWidth: 2.2,
      displacement: displacement,
      edgeOffset: edgeOffset,
      elevation: 0,
      semanticsLabel: l10n.pullToRefresh,
      semanticsValue: l10n.refreshing,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: child,
    );
  }
}
