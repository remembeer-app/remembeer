import 'dart:io';

import 'package:dartvex/dartvex.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remembeer/avatar/constants.dart';
import 'package:remembeer/convex_api/api.dart';

class AvatarService {
  final ConvexApi _api;
  final ConvexStorage _storage;
  final ImagePicker _imagePicker;

  AvatarService({required ConvexApi api, required ConvexStorage storage})
    : _api = api,
      _storage = storage,
      _imagePicker = ImagePicker();

  Future<String?> changeAvatar(BuildContext context, ImageSource source) async {
    final pickedImage = await _pickImage(source);
    if (pickedImage == null || !context.mounted) {
      return null;
    }

    final croppedImage = await _cropImage(context, pickedImage);
    if (croppedImage == null) {
      return null;
    }

    return _uploadAvatar(croppedImage);
  }

  Future<String?> _uploadAvatar(File image) async {
    final storageId = await _storage.uploadFile(
      uploadUrlAction: 'user:generateAvatarUploadUrl',
      bytes: await image.readAsBytes(),
      filename: 'avatar.jpg',
      contentType: 'image/jpeg',
    );
    return _api.user.updateAvatar(storageId: StorageId(storageId));
  }

  Future<void> deleteAvatar() async {
    await _api.user.updateAvatar(storageId: null);
  }

  Future<File?> _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile == null) {
      return null;
    }

    return File(pickedFile.path);
  }

  Future<File?> _cropImage(BuildContext context, File image) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: avatarMaxSize,
      maxWidth: avatarMaxSize,
      compressQuality: avatarCompressQuality,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Avatar',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          cropStyle: CropStyle.circle,
        ),
        IOSUiSettings(
          title: 'Crop Avatar',
          aspectRatioLockEnabled: true,
          cropStyle: CropStyle.circle,
        ),
      ],
    );

    if (croppedFile == null) {
      return null;
    }

    return File(croppedFile.path);
  }
}
