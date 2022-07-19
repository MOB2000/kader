import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/user_type.dart';
import 'package:kader/services/auth_helper.dart';
import 'package:kader/services/firebase_storage_helper.dart';
import 'package:kader/services/firestore_helper.dart';
import 'package:kader/services/shared_preferences_helper.dart';

class AuthProvider with ChangeNotifier {
  final AuthHelper _authHelper = AuthHelper.instance;

  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  late CustomUser user;

  AuthProvider() {
    user = _authHelper.currentUser;
  }

  Future<void> logout() async {
    await _authHelper.logout();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final id = await _authHelper.login(email, password);
    if (id == null) {
      return;
    }
    user = await _firestoreHelper.getUser(id);
    await saveUserLocal();
  }

  Future<void> register(String email, String password, File imageFile) async {
    final photoUrl = await FirebaseStorageHelper.instance.uploadFile(imageFile);
    user.photoUrl = photoUrl;

    final uid = await _authHelper.register(email, password);
    if (uid == null) {
      return;
    }
    user.id = uid;
    user.type = UserType.employee;
    await _firestoreHelper.addUser(user);
    await saveUserLocal();
  }

  Future<List<CustomUser>> get staff async {
    return [
      ...await _firestoreHelper.managers,
      ...await _firestoreHelper.employees,
    ];
  }

  Future<List<CustomUser>> get managersWithoutDepartments async {
    return _firestoreHelper.managersWithoutDepartments;
  }

  Future<List<CustomUser>> get managers async {
    return _firestoreHelper.managers;
  }

  Future<List<CustomUser>> get employees async {
    return _firestoreHelper.employees;
  }

  Future<void> updateUser(CustomUser user) async {
    await _firestoreHelper.updateUser(user);
    notifyListeners();
  }

  Future<void> saveUserLocal() async {
    await SharedPreferencesHelper.instance.setUser(user);
    await SharedPreferencesHelper.instance.setIsLogged(true);
  }
}
