import 'package:bai_market/core/secure_token_storage.dart';
import 'package:bai_market/features/cart/data/models/cart_model.dart';
import 'package:bai_market/features/create_order/presentation/pages/create_order_page.dart';
import 'package:bai_market/features/orders/data/models/order_model.dart';
import 'package:bai_market/features/payment/presentation/pages/payment_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/collection/presentation/pages/collection_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/menu/presentation/pages/menu_page.dart';
import '../../features/my_address/presentation/pages/my_address_page.dart';
import '../../features/my_data/presentation/pages/my_data_page.dart';
import '../../features/notification/presentation/pages/notification_list.dart';
import '../../features/notification/presentation/pages/notification_page.dart';
import '../../features/order/presentation/pages/order_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/prizes/presentation/pages/prizes_page.dart';
import '../../features/product/presentation/pages/123.dart';
import '../../features/profile/data/models/profile_model.dart';
import '../../features/tickets/presentation/pages/tickets_page.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final token = await getAuthToken();
    final isOnAuth = state.matchedLocation == '/' ||
        state.matchedLocation == '/auth';
    if (token != null && isOnAuth) return '/main';
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => AuthPage()),
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
      builder: (context, state) => MenuPage(initialPage: 'home'),
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
    GoRoute(path: '/prizes', builder: (context, state) => PrizesPage()),
    GoRoute(path: '/tickets', builder: (context, state) => TicketsPage()),
    GoRoute(
      path: '/payment',
      redirect: (context, state) =>
          state.extra is String ? null : '/main',
      builder: (context, state) {
        final url = state.extra as String;
        return PaymentPage(paymentUrl: url);
      },
    ),
    GoRoute(
      path: '/collection/:slug',
      builder:
          (context, state) =>
              CollectionPage(slug: state.pathParameters['slug']),
    ),
  ],
);
