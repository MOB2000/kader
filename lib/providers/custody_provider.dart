import 'package:flutter/material.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/models/custody_transfer_request.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/services/firestore_helper.dart';

class CustodyProvider with ChangeNotifier {
  final FirestoreHelper firestoreHelper = FirestoreHelper.instance;

  Future<List<Custody>> get custodiesWithReply async =>
      firestoreHelper.custodiesWithReply;

  Future<List<Custody>> get custodiesWithoutReply async =>
      firestoreHelper.custodiesWithoutReply;

  Future<List<Custody>> getUserCustodies(CustomUser user) async =>
      firestoreHelper.getUserCustodies(user);

  Future<List<Custody>> getCustodyByOwnerId(String ownerId) async {
    return await firestoreHelper.getCustodyByOwnerId(ownerId);
  }

  Future<void> addCustody(Custody custody) async {
    await firestoreHelper.addCustody(custody);
    notifyListeners();
  }

  Future<void> updateCustody(Custody custody) async {
    await firestoreHelper.updateCustody(custody);
    notifyListeners();
  }

  Future<void> transferCustody(CustodyTransferRequest request) async {
    await firestoreHelper.transferCustody(request);
    notifyListeners();
  }

  Future<void> deleteCustody(Custody custody) async {
    await firestoreHelper.deleteCustody(custody);
    notifyListeners();
  }

  Future<List<CustodyTransferRequest>> get custodyTransferRequests =>
      firestoreHelper.custodyTransferRequests;

  Future<void> addCustodyTransferRequest(CustodyTransferRequest request) async {
    await firestoreHelper.addCustodyTransferRequest(request);
    notifyListeners();
  }

  Future<void> deleteCustodyTransferRequest(
    CustodyTransferRequest request,
  ) async {
    await firestoreHelper.deleteCustodyTransferRequest(request);
    notifyListeners();
  }
}
