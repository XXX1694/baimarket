import 'package:flutter/material.dart';

/// Карточка подарка из frame 38: голубо-сиреневый градиент,
/// крупное название слева, картинка справа.
class LiveGiftCard extends StatelessWidget {
  const LiveGiftCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.imageAsset,
    this.onTap,
  });

  final String title;
  final String? imageUrl;
  final String? imageAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 138,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFA9C1F2), Color(0xFFCEE8FF)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 130,
              height: 130,
              child: _buildImage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageAsset != null) {
      return Image.asset(imageAsset!, fit: BoxFit.contain);
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.card_giftcard_rounded,
          color: Colors.white70,
          size: 48,
        ),
      );
    }
    return const Icon(
      Icons.card_giftcard_rounded,
      color: Colors.white70,
      size: 48,
    );
  }
}
