import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/session/constants.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';

class SessionPictureService {
  final AuthService authService;
  final SessionController sessionController;

  final FirebaseStorage _storage;
  final ImagePicker _imagePicker;

  SessionPictureService({
    required this.authService,
    required this.sessionController,
  }) : _storage = FirebaseStorage.instance,
       _imagePicker = ImagePicker();

  String get _userId => authService.authenticatedUser.uid;

  Future<void> addPicturesFromGallery(Session session) async {
    invariant(session.isAdmin(_userId), 'Only session admin can add pictures');

    final remaining = session.picturesRemaining;

    if (remaining <= 0) {
      showErrorNotification('Maximum of $maxSessionPictures pictures reached');
      return;
    }

    final pickedPictures = await _imagePicker.pickMultiImage(
      maxWidth: maxSessionPictureSize,
      maxHeight: maxSessionPictureSize,
      imageQuality: sessionPictureCompressQuality,
      limit: remaining,
    );

    if (pickedPictures.isEmpty) {
      return;
    }

    final exceedsLimit = pickedPictures.length > remaining;
    final picturesToUpload = exceedsLimit
        ? pickedPictures.take(remaining).toList()
        : pickedPictures;

    if (exceedsLimit) {
      showNotification(
        remaining == 1
            ? 'You can only add 1 more picture. Using the first selected one.'
            : 'You can only add $remaining more pictures. Using the first $remaining.',
      );
    }

    final urls = await Future.wait(
      picturesToUpload.map(
        (picture) => _upload(session.id, File(picture.path)),
      ),
    );

    await sessionController.addPicturesAtomic(session.id, urls);
  }

  Future<void> addPictureFromCamera(Session session) async {
    invariant(session.isAdmin(_userId), 'Only session admin can add pictures');

    if (session.picturesRemaining <= 0) {
      showErrorNotification('Maximum of $maxSessionPictures pictures reached');
      return;
    }

    final pickedPicture = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: maxSessionPictureSize,
      maxHeight: maxSessionPictureSize,
      imageQuality: sessionPictureCompressQuality,
    );

    if (pickedPicture == null) {
      return;
    }

    final url = await _upload(session.id, File(pickedPicture.path));

    await sessionController.addPicturesAtomic(session.id, [url]);
  }

  Future<void> deleteSessionPicture(Session session, String url) async {
    invariant(
      session.isAdmin(_userId),
      'Only session admin can remove pictures',
    );

    try {
      await _storage.refFromURL(url).delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') {
        rethrow;
      }
    }

    await sessionController.removePictureAtomic(session.id, url);
  }

  Future<String> _upload(String sessionId, File file) async {
    final ref = _storage.ref().child(
      'sessions/$sessionId/${sessionController.generateId()}.jpg',
    );

    final snapshot = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return snapshot.ref.getDownloadURL();
  }
}
