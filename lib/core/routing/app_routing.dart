import 'package:bai_market/core/secure_token_storage.dart';
import 'package:bai_market/core/services/app_logger.dart';
import 'package:bai_market/features/cart/data/models/cart_model.dart';
import 'package:bai_market/features/create_order/presentation/pages/create_order_page.dart';
import 'package:bai_market/features/orders/data/models/order_model.dart';
import 'package:bai_market/features/live/presentation/pages/live_page.dart';
import 'package:bai_market/features/order_success/data/models/order_success_args.dart';
import 'package:bai_market/features/order_success/presentation/pages/order_success_page.dart';
import 'package:bai_market/features/payment/data/models/payment_args.dart';
import 'package:bai_market/features/payment/presentation/pages/payment_page.dart';
import 'package:bai_market/features/payment/presentation/pages/payment_webview_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/cards/presentation/pages/my_cards_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/main/data/models/banner_model.dart';
import '../../features/main/presentation/pages/banner_page.dart';
import '../../features/collection/presentation/pages/collection_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/menu/presentation/pages/menu_page.dart';
import '../../features/my_address/presentation/pages/my_address_page.dart';
import '../../features/my_data/presentation/pages/my_data_page.dart';
import '../../features/notification/presentation/pages/notification_list.dart';
import '../../features/notification/presentation/pages/notification_page.dart';
import '../../features/order/presentation/pages/order_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/plus/presentation/pages/plus_history_page.dart';
import '../../features/plus/presentation/pages/plus_page.dart';
import '../../features/prizes/presentation/pages/prizes_page.dart';
import '../../features/product/data/models/product_model.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/product/presentation/pages/product_reviews_page.dart';
import '../../features/raffle/presentation/pages/raffle_detail_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/profile/data/models/profile_model.dart';
import '../../features/tickets/presentation/pages/tickets_page.dart';

const _protectedPaths = <String>{
  '/profile',
  '/cart',
  '/make_order',
  '/payment',
  '/payment_webview',
  '/order_success',
  '/orders',
  '/order',
  '/my_data',
  '/my_address',
  '/my_cards',
  '/favorites',
  '/tickets',
  '/plus',
  '/plus/history',
  '/notification',
  '/prizes',
  '/live',
};

bool _isProtected(String path) {
  if (_protectedPaths.contains(path)) return true;
  return path.startsWith('/notification/');
}

final router = GoRouter(
  initialLocation: '/main',
  redirect: (context, state) async {
    final loc = state.matchedLocation;
    if (loc == '/') {
      routerLog.nav('/ → /main');
      return '/main';
    }
    final token = await getAuthToken();
    final isOnAuth = loc == '/auth' || loc.startsWith('/auth/');
    if (token != null && isOnAuth) {
      routerLog.nav('authed user on $loc → /main');
      return '/main';
    }
    if (token == null && !isOnAuth && _isProtected(loc)) {
      routerLog.nav('guest on protected $loc → /auth');
      return '/auth';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/auth', builder: (context, state) => AuthPage()),
    GoRoute(
      path: '/auth/otp/:phoneNumber',
      builder:
          (context, state) =>
              OtpPage(
                phoneNumber: Uri.decodeComponent(
                  state.pathParameters['phoneNumber'] ?? '',
                ),
              ),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => MenuPage(initialPage: 'catalog'),
    ),
    GoRoute(
      path: '/catalog',
      builder: (context, state) => MenuPage(initialPage: 'catalog'),
    ),

    GoRoute(
      path: '/cart',
      builder: (context, state) => MenuPage(initialPage: 'cart'),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => MenuPage(initialPage: 'profile'),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) => ProductPage(id: state.pathParameters['id']),
    ),
    GoRoute(
      path: '/product/:id/reviews',
      redirect: (context, state) => state.extra is ProductModel
          ? null
          : '/product/${state.pathParameters['id']}',
      builder: (context, state) => ProductReviewsPage(
        product: state.extra as ProductModel,
      ),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => NotificationList(),
    ),
    GoRoute(
      path: '/notification/:id',
      builder:
          (context, state) => NotificationPage(id: state.pathParameters['id']),
    ),
    GoRoute(path: '/orders', builder: (context, state) => OrdersPage()),
    GoRoute(
      path: '/order',
      redirect: (context, state) =>
          state.extra is OrderModel ? null : '/orders',
      builder: (context, state) {
        final order = state.extra as OrderModel;
        return OrderPage(orderModel: order);
      },
    ),
    GoRoute(
      path: '/my_data',
      redirect: (context, state) =>
          state.extra is ProfileModel ? null : '/profile',
      builder: (context, state) {
        final profile = state.extra as ProfileModel;
        return MyDataPage(profileModel: profile);
      },
    ),
    GoRoute(path: '/my_address', builder: (context, state) => MyAddressPage()),
    GoRoute(path: '/my_cards', builder: (context, state) => const MyCardsPage()),
    GoRoute(
      path: '/make_order',
      redirect: (context, state) =>
          state.extra is CartModel ? null : '/cart',
      builder: (context, state) {
        final cart = state.extra as CartModel;
        return CreateOrderPage(cartModel: cart);
      },
    ),
    GoRoute(path: '/favorites', builder: (context, state) => FavoritesPage()),
    GoRoute(
      path: '/banner',
      redirect: (context, state) =>
          state.extra is BannerModel ? null : '/main',
      builder: (context, state) {
        final banner = state.extra as BannerModel;
        return BannerPage(banner: banner);
      },
    ),
    GoRoute(path: '/plus', builder: (context, state) => const PlusPage()),
    GoRoute(
      path: '/plus/history',
      builder: (context, state) => const PlusHistoryPage(),
    ),
    GoRoute(path: '/prizes', builder: (context, state) => PrizesPage()),
    GoRoute(
      path: '/shop',
      builder: (context, state) {
        // Параметризован через extra: {title: 'Имя\nФамилия'}.
        // Если ничего не передано — открываем дефолтный shop (mock id=-1).
        final extra = state.extra;
        String title = 'Ырысбала\nИкрамбай';
        if (extra is Map && extra['title'] is String) {
          title = extra['title'] as String;
        }
        return RaffleDetailPage(id: -1, titleOverride: title);
      },
    ),
    GoRoute(path: '/tickets', builder: (context, state) => TicketsPage()),
    GoRoute(
      path: '/payment',
      redirect: (context, state) {
        final extra = state.extra;
        if (extra is PaymentArgs) return null;
        if (extra is String) return null;
        return '/main';
      },
      builder: (context, state) {
        final extra = state.extra;
        if (extra is PaymentArgs) return PaymentPage(args: extra);
        // Совместимость со старым вызовом — оборачиваем URL.
        return PaymentPage(
          args: PaymentArgs(amount: 0, paymentUrl: extra as String),
        );
      },
    ),
    GoRoute(
      path: '/payment_webview',
      redirect: (context, state) =>
          state.extra is PaymentArgs ? null : '/main',
      builder: (context, state) =>
          PaymentWebViewPage(args: state.extra as PaymentArgs),
    ),
    GoRoute(
      path: '/order_success',
      redirect: (context, state) =>
          state.extra is OrderSuccessArgs ? null : '/main',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        opaque: false,
        barrierDismissible: false,
        fullscreenDialog: true,
        child: OrderSuccessPage(args: state.extra as OrderSuccessArgs),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(path: '/live', builder: (context, state) => const LivePage()),
    GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
    GoRoute(
      path: '/collection/:slug',
      builder: (context, state) {
        // extra: {title: 'Парфюмерия'} прокидывается из плиток каталога,
        // чтобы шапка показывала имя категории, а не дефолт от бэка.
        String? titleOverride;
        final extra = state.extra;
        if (extra is Map && extra['title'] is String) {
          titleOverride = extra['title'] as String;
        }
        return CollectionPage(
          slug: state.pathParameters['slug'],
          titleOverride: titleOverride,
        );
      },
    ),
    GoRoute(
      path: '/raffle/:id',
      redirect: (context, state) {
        final raw = state.pathParameters['id'];
        return int.tryParse(raw ?? '') == null ? '/catalog' : null;
      },
      builder: (context, state) => RaffleDetailPage(
        id: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);
