import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kader/constants/keys.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/models/custom_user.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper instance = FirestoreHelper._();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> checkIdExists(String id) async {
    final result = await _firebaseFirestore
        .collection('users')
        .where(Keys.id, isEqualTo: id)
        .get();

    return result.size != 0;
  }

  Future<void> addUser(CustomUser user) async {
    await _firebaseFirestore.collection('users').add(user.toMap());
  }

  Future<void> updateUser(CustomUser user) async {
    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<CustomUser> getUser(String id) async {
    final doc = await _firebaseFirestore
        .collection('users')
        .where('id', isEqualTo: id)
        .get()
        .then((value) => value.docs.first);

    final user = CustomUser.fromMap(doc.data());
    return user;
  }

  Future<void> addComplaint(Complaint complaint) async {
    await _firebaseFirestore.collection('complaints').add(complaint.toMap());
  }

  Future<List<Complaint>> get complaints async =>
      await _firebaseFirestore.collection('complaints').get().then((value) =>
          value.docs.map((e) => Complaint.fromMap(e.data())).toList());

  Future<List<Complaint>> getComplaints(String ownerId) async {
    final complaints = await _firebaseFirestore
        .collection('complaints')
        .where('ownerId', isEqualTo: ownerId)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => Complaint.fromMap(e.data())).toList(),
        );
    return complaints;
  }
}
