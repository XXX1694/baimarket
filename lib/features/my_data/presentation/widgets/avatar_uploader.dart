import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/app_dio.dart';
import '../../../../core/urls.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import 'add_photo_bottom_sheet.dart';
import 'avatar_selector_section.dart';

class AvatarUploader extends StatefulWidget {
  const AvatarUploader({
    super.key,
    required this.initial,
    required this.imageUrl,
    required this.baseLabel,
    required this.selectLabel,
  });

  final String initial;
  final String imageUrl;
  final String baseLabel;
  final String selectLabel;

  @override
  State<AvatarUploader> createState() => _AvatarUploaderState();
}

class _AvatarUploaderState extends State<AvatarUploader> {
  final ImagePicker _picker = ImagePicker();
  final Dio _dio = appDio;
  File? _local;
  bool _uploading = false;

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (file == null) return;
      setState(() {
        _local = File(file.path);
        _uploading = true;
      });
      await _upload();
    } catch (_) {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _upload() async {
    if (_local == null) return;
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(_local!.path),
      });
      final res = await _dio.post(
        '${mainUrl}profile/avatar',
        data: form,
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        if (mounted) context.read<ProfileCubit>().getProfileData();
      }
    } catch (_) {
      // silently ignore — the local preview still reflects the pick
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  void _openSheet() {
    AddPhotoBottomSheet.show(
      context: context,
      onSourceSelected: _pick,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AvatarSelectorSection(
      initial: widget.initial,
      imageUrl: widget.imageUrl,
      baseLabel: widget.baseLabel,
      selectLabel: widget.selectLabel,
      localImage: _local,
      isUploading: _uploading,
      onPickPhoto: _openSheet,
    );
  }
}
