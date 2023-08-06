import 'package:flutter/material.dart';
import 'package:kader/models/department.dart';
import 'package:kader/models/vacation_request.dart';
import 'package:kader/services/firestore_helper.dart';

import '../models/custom_user.dart';

class VacationsProvider with ChangeNotifier {
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  Future<void> addVacationRequest(VacationRequest vacationRequest) async {
    await _firestoreHelper.addVacationRequest(vacationRequest);
    notifyListeners();
  }

  Future<List<VacationRequest>> getDepartmentVacations(
    Department department,
  ) async {
    return await _firestoreHelper.getDepartmentVacations(department);
  }

  Future<List<VacationRequest>> getEmployeeVacations(CustomUser user) async {
    return await _firestoreHelper.getEmployeeVacations(user);
  }

  Future<void> updateVacation(VacationRequest vacationRequest) async {
    await _firestoreHelper.updateVacation(vacationRequest);
    notifyListeners();
  }
}
