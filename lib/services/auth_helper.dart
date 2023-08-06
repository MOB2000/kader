import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/services/shared_preferences_helper.dart';

class AuthHelper with ChangeNotifier {
  AuthHelper._();

  static final AuthHelper instance = AuthHelper._();

  late CustomUser currentUser = CustomUser.empty();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> register(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!.uid;
  }

  Future<String?> login(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user?.uid;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await SharedPreferencesHelper.instance.setIsLogged(false);
  }
}
