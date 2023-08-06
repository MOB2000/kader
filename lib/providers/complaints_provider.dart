import 'package:flutter/material.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/services/firestore_helper.dart';

class ComplaintsProvider with ChangeNotifier {
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  Future<void> addComplaint(Complaint complaint) async {
    await _firestoreHelper.addComplaint(complaint);
    notifyListeners();
  }

  Future<List<Complaint>> get complaints async =>
      await _firestoreHelper.complaints;

  Future<List<Complaint>> getComplaints(String ownerId) async {
    return await _firestoreHelper.getComplaints(ownerId);
  }

  Future<void> updateComplaints(Complaint complaint) async {
    await _firestoreHelper.updateComplaint(complaint);
    notifyListeners();
  }
}
