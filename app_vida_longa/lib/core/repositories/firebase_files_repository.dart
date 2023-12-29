import 'dart:io';

import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class IFilesRepository {
  Future<String?> uploadPhoto(File file);
}

class FilesRepository implements IFilesRepository {
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;
  @override
  Future<String?> uploadPhoto(File file) async {
    try {
      String ref =
          'users/${UserService.instance.user.id}/profile/${file.path.split('/').last}';
      await _fireStorage.ref(ref).putFile(file);

      return await _fireStorage.ref(ref).getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
