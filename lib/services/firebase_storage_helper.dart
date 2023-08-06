import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:kader/constants/keys.dart';

class FirebaseStorageHelper {
  FirebaseStorageHelper._();

  static final FirebaseStorageHelper instance = FirebaseStorageHelper._();

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    final ref = _firebaseStorage
        .ref()
        .child('${Keys.profilesImages}/${file.path.split('/').last}');
    await ref.putFile(file);

    final photoUrl = await ref.getDownloadURL();

    return photoUrl;
  }
}
