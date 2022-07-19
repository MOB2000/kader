import 'package:flutter/material.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/department.dart';
import 'package:kader/services/firestore_helper.dart';

class DepartmentsProvider with ChangeNotifier {
  final _firestore = FirestoreHelper.instance;

  Future<List<Department>> get departments async => _firestore.departments;

  Future<List<CustomUser>> get employees async => _firestore.employees;

  Future<Department> getDepartmentByManager(CustomUser manager) {
    return _firestore.getDepartmentByManager(manager);
  }

  Future<Department> getDepartmentByEmployee(CustomUser employee) {
    return _firestore.getDepartmentByEmployee(employee);
  }

  Future<void> createDepartment(String name, String managerId) async {
    final department = Department(name: name, managerId: managerId);
    await _firestore.createDepartment(department);
    notifyListeners();
  }

  Future<void> updateDepartment(Department department) async {
    await _firestore.updateDepartment(department);
  }

  Future<void> deleteDepartment(Department department) async {
    await _firestore.deleteDepartment(department);
    notifyListeners();
  }

  Future<bool> checkManagerHasDepartment(CustomUser manager) {
    return _firestore.checkManagerHasDepartment(manager);
  }

  Future<CustomUser> getDepartmentManager(Department department) async {
    return _firestore.getDepartmentManager(department);
  }

  Future<List<CustomUser>> getDepartmentEmployees(Department department) async {
    return await _firestore.getDepartmentEmployees(department);
  }

  Future<void> addEmployeesToDepartment(
    List<CustomUser> employees,
    Department department,
  ) async {
    await _firestore.addEmployeesToDepartment(employees, department);
    notifyListeners();
  }

  Future<void> removeEmployeeFromDepartment(
    CustomUser employee,
    Department department,
  ) async {
    await _firestore.removeEmployeeFromDepartment(employee, department);
    notifyListeners();
  }

  Future<List<CustomUser>> getEmployeesWithoutDepartment(
    Department department,
  ) async {
    return _firestore.employeesWithoutDepartment(department);
  }

  Future<Department> getDepartmentByManagerId(String managerId) async {
    return _firestore.getDepartmentByManagerId(managerId);
  }

  Future<Department> getDepartmentById(String id) async {
    return _firestore.getDepartmentById(id);
  }
}
