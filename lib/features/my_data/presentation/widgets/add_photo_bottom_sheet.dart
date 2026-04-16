import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';

class AddPhotoBottomSheet extends StatelessWidget {
  const AddPhotoBottomSheet({super.key, required this.onSourceSelected});

  final ValueChanged<ImageSource> onSourceSelected;

  static Future<void> show({
    required BuildContext context,
    required ValueChanged<ImageSource> onSourceSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (ctx) => AddPhotoBottomSheet(onSourceSelected: onSourceSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SheetHeader(title: l10n.addPhoto),
            const SizedBox(height: 12),
            _PhotoSourceTile(
              icon: Icons.photo_library_outlined,
              label: l10n.gallery,
              onTap: () {
                Navigator.pop(context);
                onSourceSelected(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
            _PhotoSourceTile(
              icon: Icons.camera_alt_outlined,
              label: l10n.camera,
              onTap: () {
                Navigator.pop(context);
                onSourceSelected(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightGray,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size(28, 28),
            onPressed: () => Navigator.pop(context),
            child: Container(
              height: 24,
              width: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFE3E3E3),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.close, size: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSourceTile extends StatelessWidget {
  const _PhotoSourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF8A8A8A), size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8A8A8A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
