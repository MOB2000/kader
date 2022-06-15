import 'package:firebase_auth/firebase_auth.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/gender.dart';
import 'package:kader/models/user_type.dart';

class AuthHelper {
  AuthHelper._();

  static final AuthHelper instance = AuthHelper._();

  late CustomUser currentUser = CustomUser(
    id: '',
    type: UserType.employee,
    password: '',
    phoneNumber: '',
    idNumber: '',
    photo: '',
    name: '',
    email: '',
    gender: Gender.male,
  );

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> register(CustomUser user) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
    return userCredential.user!.uid;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<String> login(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!.uid;
  }
}
