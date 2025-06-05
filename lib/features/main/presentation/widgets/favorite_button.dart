import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../profile/presentation/pages/profile_page.dart';

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
    setState(() {
      _isFavorite = !_isFavorite;
    });

    final cubit = context.read<FavoritesCubit>();
    try {
      if (!_isFavorite) {
        await cubit.removeFromFavoritesById(id: widget.productId);
      } else {
        await cubit.addfavorite(id: widget.productId);
      }
      profileCubitGlobal.getProfileData();
    } catch (e) {
      // В случае ошибки возвращаем предыдущее состояние
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: SvgPicture.asset(
        _isFavorite ? 'assets/icons/liked.svg' : 'assets/icons/like_main.svg',
      ),
    );
  }
}
