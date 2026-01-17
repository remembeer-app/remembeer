import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/avatar/constants.dart';
import 'package:remembeer/user/controller/user_controller.dart';

class AvatarService {
  final AuthService authService;
  final UserController userController;

  final FirebaseStorage _storage;
  final ImagePicker _imagePicker;

  AvatarService({required this.authService, required this.userController})
    : _storage = FirebaseStorage.instance,
      _imagePicker = ImagePicker();

  String get _userId => authService.authenticatedUser.uid;

  String get _avatarPath => 'avatars/$_userId.jpg';

  Future<String?> changeAvatar({required BuildContext context}) async {
    final pickedImage = await _pickImage();
    if (pickedImage == null || !context.mounted) {
      return null;
    }

    final croppedImage = await _cropImage(context, pickedImage);
    if (croppedImage == null) {
      return null;
    }

    final downloadUrl = await _uploadAvatar(croppedImage);

    await _updateUserAvatar(downloadUrl);

    return downloadUrl;
  }

  Future<void> deleteAvatar() async {
    try {
      await _storage.ref().child(_avatarPath).delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') {
        rethrow;
      }
    }

    await _updateUserAvatar(null);
  }

  Future<File?> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

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
          toolbarWidgetColor: Colors.white,
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

  Future<String> _uploadAvatar(File image) async {
    final ref = _storage.ref().child(_avatarPath);

    final snapshot = await ref.putFile(image);

    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _updateUserAvatar(String? avatarUrl) async {
    final currentUser = await userController.currentUser;
    if (currentUser.avatarUrl == avatarUrl) {
      return;
    }

    final updatedUser = currentUser.copyWith(avatarUrl: avatarUrl);
    await userController.createOrUpdateUser(updatedUser);
  }
}
