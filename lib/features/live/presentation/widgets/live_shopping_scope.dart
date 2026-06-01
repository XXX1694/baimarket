import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../cart/data/models/cart_model.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../create_order/presentation/pages/create_order_page.dart';
import '../../../order_success/data/models/order_success_args.dart';
import '../../../order_success/presentation/pages/order_success_page.dart';
import '../../../payment/data/models/payment_args.dart';
import '../../../payment/presentation/pages/payment_page.dart';
import '../../../payment/presentation/pages/payment_webview_page.dart';
import '../../../product/presentation/pages/product_page.dart';

/// Marks every modal route opened by [LiveShoppingController] so we can pop
/// the whole stack back to /live in one shot via [Navigator.popUntil].
const String _kLiveSheetRouteName = 'live_shopping_sheet';

/// Routes shopping flow through stacked bottom sheets while the live page
/// keeps playing underneath. When [LiveShoppingScope.maybeOf] returns non-null,
/// pages should call this controller instead of `context.push(...)` /
/// `context.go(...)` so navigation never leaves the stream.
class LiveShoppingController {
  Future<void> openCart(BuildContext context) =>
      _openSheet(context, const _CartTarget());

  Future<void> openProduct(BuildContext context, int id) =>
      _openSheet(context, _ProductTarget(id));

  Future<void> openCreateOrder(BuildContext context, CartModel cart) =>
      _openSheet(context, _CreateOrderTarget(cart));

  Future<void> openPayment(BuildContext context, PaymentArgs args) =>
      _openSheet(context, _PaymentTarget(args));

  Future<void> openPaymentWebview(BuildContext context, PaymentArgs args) =>
      _openSheet(context, _PaymentWebviewTarget(args));

  Future<void> openOrderSuccess(BuildContext context, OrderSuccessArgs args) =>
      _openSheet(context, _OrderSuccessTarget(args));

  /// Pops every sheet opened by this controller back to /live.
  void closeAll(BuildContext context) {
    Navigator.of(context).popUntil(
      (route) => route.settings.name != _kLiveSheetRouteName,
    );
  }

  /// Same as [closeAll], then navigates the underlying go_router stack.
  /// Used by «View order status» on the success screen.
  void closeAllAndGo(BuildContext context, String location) {
    final router = GoRouter.of(context);
    Navigator.of(context).popUntil(
      (route) => route.settings.name != _kLiveSheetRouteName,
    );
    router.go(location);
  }

  Future<void> _openSheet(BuildContext context, _SheetTarget target) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      routeSettings: const RouteSettings(name: _kLiveSheetRouteName),
      builder: (sheetCtx) {
        return LiveShoppingScope(
          controller: this,
          child: _LiveSheetFrame(child: target.build()),
        );
      },
    );
  }
}

class LiveShoppingScope extends InheritedWidget {
  const LiveShoppingScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final LiveShoppingController controller;

  static LiveShoppingController? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<LiveShoppingScope>()
      ?.controller;

  @override
  bool updateShouldNotify(LiveShoppingScope oldWidget) =>
      controller != oldWidget.controller;
}

/// Entry points used by the live page itself.
Future<void> openLiveCartSheet(BuildContext context) =>
    LiveShoppingController().openCart(context);

Future<void> openLiveProductSheet(BuildContext context, int id) =>
    LiveShoppingController().openProduct(context, id);

class _LiveSheetFrame extends StatelessWidget {
  const _LiveSheetFrame({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SizedBox(
        height: double.infinity,
        child: child,
      ),
    );
  }
}

abstract class _SheetTarget {
  const _SheetTarget();
  Widget build();
}

class _CartTarget extends _SheetTarget {
  const _CartTarget();
  @override
  Widget build() => const CartPage(toCatalog: null);
}

class _ProductTarget extends _SheetTarget {
  const _ProductTarget(this.id);
  final int id;
  @override
  Widget build() => ProductPage(id: id.toString());
}

class _CreateOrderTarget extends _SheetTarget {
  const _CreateOrderTarget(this.cart);
  final CartModel cart;
  @override
  Widget build() => CreateOrderPage(cartModel: cart);
}

class _PaymentTarget extends _SheetTarget {
  const _PaymentTarget(this.args);
  final PaymentArgs args;
  @override
  Widget build() => PaymentPage(args: args);
}

class _PaymentWebviewTarget extends _SheetTarget {
  const _PaymentWebviewTarget(this.args);
  final PaymentArgs args;
  @override
  Widget build() => PaymentWebViewPage(args: args);
}

class _OrderSuccessTarget extends _SheetTarget {
  const _OrderSuccessTarget(this.args);
  final OrderSuccessArgs args;
  @override
  Widget build() => OrderSuccessPage(args: args);
}
