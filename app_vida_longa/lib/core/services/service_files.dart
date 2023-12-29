import 'dart:io';

import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/repositories/firebase_files_repository.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

abstract class IFilesService {
  Future<XFile?> pickFromGallery();
  Future<bool> uploadFile(File file);
  Future<bool> updateUserUrlPhoto(String url);
  Future deleteFile(File file);
}

class FilesService implements IFilesService {
  @override
  Future<XFile?> pickFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      return image;
    } on PlatformException {
      AppHelper.displayAlertError("Erro ao carregar imagem.");
    }
    return null;
  }

  @override
  Future<bool> uploadFile(File file) async {
    bool result = false;
    try {
      IFilesRepository repository = FilesRepository();
      final url = await repository.uploadPhoto(file);
      if (url == null) return result;
      result = await updateUserUrlPhoto(url);
      if (result) {
        AppHelper.displayAlertSuccess("Foto atualizada com sucesso.");
      } else {
        AppHelper.displayAlertError("Erro ao atualizar foto.");
      }
      deleteFile(file);
    } on PlatformException {
      AppHelper.displayAlertError("Erro ao carregar imagem.");
    }
    return result;
  }

  @override
  Future<bool> updateUserUrlPhoto(String url) async {
    try {
      await UserService.instance.uploadPhoto(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteFile(File file) async {
    bool result = false;
    await file.delete().then((value) {
      result = true;
    }).onError((error, stackTrace) {
      result = false;
    });
    return result;
  }
}
