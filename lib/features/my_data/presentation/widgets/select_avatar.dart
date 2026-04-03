import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../../../core/secure_token_storage.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/urls.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';

final profileCubitGlobal = ProfileCubit();

class SelectAvatar extends StatefulWidget {
  const SelectAvatar({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  State<SelectAvatar> createState() => _SelectAvatarState();
}

class _SelectAvatarState extends State<SelectAvatar> {
  File? _image;
  final _picker = ImagePicker();
  final _dio = Dio();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isUploading = true;
        });

        await _uploadImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      final token = await getAuthToken();
      if (token == null) throw Exception('No auth token found');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_image!.path),
      });

      final response = await _dio.post(
        '${mainUrl}profile/avatar',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        // Update profile data
        profileCubitGlobal.getProfileData();

        if (mounted) {
          // Navigate back to profile page
          context.go('/profile');
        }
      } else {
        throw Exception('Failed to upload avatar');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading avatar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showImageSourceActionSheet() {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder:
            (BuildContext context) => CupertinoActionSheet(
              title: const Text('Choose Photo'),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  child: const Text('Take Photo'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text('Choose from Library'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder:
            (BuildContext context) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Choose from Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _isUploading ? null : _showImageSourceActionSheet,
      child: Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(12),
          image:
              _image != null
                  ? DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child:
            widget.imageUrl.isNotEmpty
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: NetworkImageWidget(url: '$imgUrl${widget.imageUrl}'),
                )
                : _isUploading
                ? const Center(child: CupertinoActivityIndicator())
                : _image == null
                ? const Center(
                  child: Icon(Icons.photo, color: Colors.grey, size: 28),
                )
                : null,
      ),
    );
  }
}
