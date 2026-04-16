import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/urls.dart';
import '../../../../core/widgets/show_image.dart';

class PhotoAvatarTile extends StatelessWidget {
  const PhotoAvatarTile({
    super.key,
    required this.imageUrl,
    this.localImage,
    this.isUploading = false,
    this.onTap,
  });

  final String imageUrl;
  final File? localImage;
  final bool isUploading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUploading ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isUploading) {
      return const Center(child: CupertinoActivityIndicator());
    }
    if (localImage != null) {
      return Image.file(localImage!, fit: BoxFit.cover);
    }
    if (imageUrl.isNotEmpty) {
      return NetworkImageWidget(url: '$imgUrl$imageUrl');
    }
    return const Center(
      child: Icon(
        Icons.image_outlined,
        color: Color(0xFFB5B5B5),
        size: 28,
      ),
    );
  }
}
