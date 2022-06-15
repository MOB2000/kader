import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/services/auth_helper.dart';
import 'package:kader/services/firestor_helper.dart';
import 'package:kader/services/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthHelper _authHelper = AuthHelper.instance;

  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  late CustomUser user;

  AuthProvider() {
    user = _authHelper.currentUser;
  }

  Future<void> logout() async {
    await _authHelper.logout();
    await SharedPrefs.instance.setIsLogged(false);
  }

  Future<void> login(String email, String password) async {
    final id = await _authHelper.login(email, password);
    //  TODO: check login
    user = await _firestoreHelper.getUser(id);
    await saveUserLocal();
  }

  Future<void> saveUserLocal() async {
    await SharedPrefs.instance.setUser(user);
    await SharedPrefs.instance.setIsLogged(true);
  }

  Future<void> register(File imageFile) async {
    final isIdExists = await _firestoreHelper.checkIdExists(user.idNumber);
    if (isIdExists) {
      throw Exception('رقجوم الهوية مود');
    }
    final ref = FirebaseStorage.instance
        .ref()
        .child('profiles_images${imageFile.path.split('/').last}');
    await ref.putFile(imageFile);

    final photoUrl = await ref.getDownloadURL();
    user = user.copyWith(photo: photoUrl);

    final uid = await _authHelper.register(user);
    if (uid == null) {
      return;
    }
    user = user.copyWith(id: uid);
    await _firestoreHelper.addUser(user);
    await saveUserLocal();
  }
}
