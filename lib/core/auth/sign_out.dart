import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/create_order/presentation/cubit/create_order_cubit.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../features/notification/presentation/cubit/notification_cubit.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import 'pending_action.dart';

/// Centralized logout: drops the token, wipes user-specific cubit state,
/// clears any pending post-login action, and routes to /auth.
Future<void> signOutAndCleanup(BuildContext context) async {
  PendingAuthAction.clear();
  resetUserCubits(context);
  await context.read<AuthCubit>().logOut();
  if (context.mounted) context.go('/auth');
}

/// Resets every user-specific cubit registered at app root so leftover state
/// from the previous user doesn't leak into the next session.
void resetUserCubits(BuildContext context) {
  context.read<CartCubit>().reset();
  context.read<ProfileCubit>().reset();
  context.read<FavoritesCubit>().reset();
  context.read<OrdersCubit>().reset();
  context.read<NotificationCubit>().reset();
  context.read<CreateOrderCubit>().reset();
}
