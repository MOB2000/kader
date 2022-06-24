import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kader/constants/keys.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/department.dart';

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

    return CustomUser.fromMap(doc.data());
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

  Future<void> createDepartment(Department department) async {
    department.id = await _firebaseFirestore
        .collection('departments')
        .add(department.toMap())
        .then((value) => value.id);

    await updateDepartment(department);
  }

  Future<void> updateDepartment(Department department) async {
    await _firebaseFirestore
        .collection('departments')
        .doc(department.id)
        .set(department.toMap());
  }

  Future<List<CustomUser>> get managers async {
    return await _firebaseFirestore
        .collection('users')
        .where('type', isEqualTo: 'manager')
        .get()
        .then((value) =>
            value.docs.map((doc) => CustomUser.fromMap(doc.data())).toList());
  }

  Future<List<Department>> get departments async {
    return await _firebaseFirestore
        .collection('departments')
        .get()
        .then((value) {
      return value.docs.map((doc) => Department.fromMap(doc.data())).toList();
    });
  }

  Future<void> deleteDepartment(Department department) async {
    await _firebaseFirestore
        .collection('departments')
        .doc(department.id)
        .delete();
  }

  Future<List<CustomUser>> get employees async {
    return await _firebaseFirestore
        .collection('users')
        .where('type', isEqualTo: 'employee')
        .get()
        .then((value) =>
            value.docs.map((doc) => CustomUser.fromMap(doc.data())).toList());
  }

  Future<CustomUser> getDepartmentManager(Department department) async {
    return _firebaseFirestore
        .collection('users')
        .where('id', isEqualTo: department.managerId)
        .get()
        .then((value) => CustomUser.fromMap(value.docs.first.data()));
  }

  Future<void> addEmployeesToDepartments(
    List<CustomUser> employees,
    Department department,
  ) async {
    _firebaseFirestore
        .collection('employees_departments')
        .where('department_id')
        .get()
        .then((value) async {
      final ids = value.docs.map((element) {
        return element.id;
      });
      ids.forEach((id) async {
        await _firebaseFirestore
            .collection('employees_departments')
            .doc(id)
            .delete();
      });
    });
    employees.forEach((employee) async {
      await _firebaseFirestore.collection('employees_departments').add({
        'emp_id': employee.id,
        'department_id': department.id,
      });
    });
  }

  Future<void> removeEmployeeFromDepartment(
    CustomUser employee,
    Department department,
  ) async {
    final id = await _firebaseFirestore
        .collection('employees_departments')
        .where('emp_id', isEqualTo: employee.id)
        .get()
        .then((value) => value.docs.first.id);
    await _firebaseFirestore
        .collection('employees_departments')
        .doc(id)
        .delete();
  }

  Future<List<CustomUser>> getDepartmentEmployees(Department department) async {
    final empsIds = await _firebaseFirestore
        .collection('employees_departments')
        .where('department_id', isEqualTo: department.id)
        .get()
        .then((value) => value.docs.map((e) => e.data()['emp_id']).toList());

    if (empsIds.isEmpty) {
      return <CustomUser>[];
    }
    return _firebaseFirestore
        .collection('users')
        .where('id', whereIn: empsIds)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => CustomUser.fromMap(e.data())).toList(),
        );
  }
}
