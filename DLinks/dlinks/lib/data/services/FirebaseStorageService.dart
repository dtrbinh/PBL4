import 'dart:io';

import 'package:dlinks/utils/error_manager/ErrorLogger.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {

  static Future<Stream<TaskSnapshot>?> uploadFile(File file, String savingPath) async {
    var fileName = file.path.split('/').last;
    try {
      final UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('$savingPath/${'${DateTime.now()}_$fileName'}')
          .putFile(file);
      return uploadTask.snapshotEvents;
    } catch (e) {
      logError(e.toString());
    }
    return null;
  }
}
