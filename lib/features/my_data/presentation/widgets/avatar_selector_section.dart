import 'dart:io';
import 'package:flutter/material.dart';

import 'base_avatar_tile.dart';
import 'photo_avatar_tile.dart';

class AvatarSelectorSection extends StatelessWidget {
  const AvatarSelectorSection({
    super.key,
    required this.initial,
    required this.imageUrl,
    required this.baseLabel,
    required this.selectLabel,
    required this.onPickPhoto,
    this.localImage,
    this.isUploading = false,
  });

  final String initial;
  final String imageUrl;
  final String baseLabel;
  final String selectLabel;
  final VoidCallback onPickPhoto;
  final File? localImage;
  final bool isUploading;

  bool get _hasCustomPhoto =>
      localImage != null || imageUrl.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AvatarColumn(
          label: baseLabel,
          child: BaseAvatarTile(
            initial: initial,
            selected: !_hasCustomPhoto,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 72,
          width: 1,
          margin: const EdgeInsets.only(top: 24),
          color: const Color(0xFFE5E5E5),
        ),
        const SizedBox(width: 12),
        _AvatarColumn(
          label: selectLabel,
          child: PhotoAvatarTile(
            imageUrl: imageUrl,
            localImage: localImage,
            isUploading: isUploading,
            onTap: onPickPhoto,
          ),
        ),
      ],
    );
  }
}

class _AvatarColumn extends StatelessWidget {
  const _AvatarColumn({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8A8A8A),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
