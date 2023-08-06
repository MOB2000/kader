import 'package:flutter/material.dart';
import 'package:kader/models/attendance.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/services/firestore_helper.dart';

class AttendanceProvider with ChangeNotifier {
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  Future<void> updateAttendance(Attendance attendance) async {
    await _firestoreHelper.updateAttendance(attendance);
    notifyListeners();
  }

  Future<List<Attendance>> getEmployeeAttendanceHistory(
      CustomUser employee) async {
    return await _firestoreHelper.getEmployeeAttendanceHistory(employee);
  }

  Future<Attendance?> checkSavedAttendance(CustomUser user) async {
    return _firestoreHelper.checkSavedAttendance(user);
  }

  Future<List<Attendance>> allDepartmentEmployeesAttendance(
      CustomUser manager) async {
    return _firestoreHelper.allDepartmentEmployeesAttendance(manager);
  }
}
