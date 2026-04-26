import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/auth/auth_gate.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';

class FavoriteButton extends StatefulWidget {
  final int productId;
  final bool isFavorite;
  const FavoriteButton({
    super.key,
    required this.productId,
    required this.isFavorite,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  void didUpdateWidget(FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      setState(() {
        _isFavorite = widget.isFavorite;
      });
    }
  }

  void _handleTap() async {
    final cubit = context.read<FavoritesCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final wantsFavorite = !_isFavorite;

    final ok = await ensureAuthenticated(
      context,
      pendingAction: () {
        if (wantsFavorite) {
          cubit.addfavorite(id: widget.productId);
        } else {
          cubit.removeFromFavoritesById(id: widget.productId);
        }
        profileCubit.getProfileData();
      },
    );
    if (!ok) return;

    setState(() {
      _isFavorite = wantsFavorite;
    });
    try {
      if (wantsFavorite) {
        await cubit.addfavorite(id: widget.productId);
      } else {
        await cubit.removeFromFavoritesById(id: widget.productId);
      }
      profileCubit.getProfileData();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFavorite = !wantsFavorite;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: SvgPicture.asset(
        _isFavorite
            ? 'assets/icons/common/product_like_active.svg'
            : 'assets/icons/common/product_like_disabled.svg',
      ),
    );
  }
}
