import 'package:flutter/material.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/services/firestore_helper.dart';

class CustodyProvider with ChangeNotifier {
  final FirestoreHelper firestoreHelper = FirestoreHelper.instance;

  Future<List<Custody>> get custodies async => firestoreHelper.custody;

  Future<List<Custody>> get custodiesWithoutReply async =>
      firestoreHelper.custodiesWithoutReply;

  Future<List<Custody>> getCustody(String ownerId) async {
    return await firestoreHelper.getCustody(ownerId);
  }

  Future<void> addCustody(Custody custody) async {
    await firestoreHelper.addCustody(custody);
    notifyListeners();
  }

  updateCustody(Custody custody) async {
    await firestoreHelper.updateCustody_reply(custody);
    notifyListeners();
  }

  deleteCustody(Custody custody) async {
    await firestoreHelper.deleteCustody(custody);
    notifyListeners();
  }
}
