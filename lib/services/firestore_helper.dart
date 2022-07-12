import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kader/constants/keys.dart';
import 'package:kader/models/attendance.dart';
import 'package:kader/models/attendance_status.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/department.dart';
import 'package:kader/models/request_status.dart';
import 'package:kader/models/vacation_request.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper instance = FirestoreHelper._();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(CustomUser user) async {
    await _firebaseFirestore.collection(Keys.users).add(user.toMap());
  }

  Future<void> updateUser(CustomUser user) async {
    final id = await _firebaseFirestore
        .collection(Keys.users)
        .where(Keys.id, isEqualTo: user.id)
        .get()
        .then((value) => value.docs.first.id);

    await _firebaseFirestore.collection(Keys.users).doc(id).set(user.toMap());
  }

  Future<CustomUser> getUser(String id) async {
    final doc = await _firebaseFirestore
        .collection(Keys.users)
        .where(Keys.id, isEqualTo: id)
        .get()
        .then((value) => value.docs.first);

    return CustomUser.fromMap(doc.data());
  }

  Future<void> createDepartment(Department department) async {
    department.id = await _firebaseFirestore
        .collection(Keys.departments)
        .add(department.toMap())
        .then((value) => value.id);

    await updateDepartment(department);
  }

  Future<void> updateDepartment(Department department) async {
    await _firebaseFirestore
        .collection(Keys.departments)
        .doc(department.id)
        .set(department.toMap());
  }

  Future<List<CustomUser>> get managersWithoutDepartments async {
    final allManagers = await managers;
    final managersWithDepartments = await _firebaseFirestore
        .collection(Keys.departments)
        .get()
        .then((value) =>
            value.docs.map((e) => e.data()[Keys.managerId]).toList());

    allManagers
        .removeWhere((element) => managersWithDepartments.contains(element.id));
    return allManagers;
  }

  Future<List<CustomUser>> get managers async {
    return await _firebaseFirestore
        .collection(Keys.users)
        .where(Keys.type, isEqualTo: Keys.manager)
        .get()
        .then((value) =>
            value.docs.map((doc) => CustomUser.fromMap(doc.data())).toList());
  }

  Future<List<Department>> get departments async {
    return await _firebaseFirestore
        .collection(Keys.departments)
        .get()
        .then((value) {
      return value.docs.map((doc) => Department.fromMap(doc.data())).toList();
    });
  }

  Future<void> deleteDepartment(Department department) async {
    await _firebaseFirestore
        .collection(Keys.departments)
        .doc(department.id)
        .delete();
  }

  Future<List<CustomUser>> get employees async {
    return await _firebaseFirestore
        .collection(Keys.users)
        .where(Keys.type, isEqualTo: Keys.employee)
        .get()
        .then((value) =>
            value.docs.map((doc) => CustomUser.fromMap(doc.data())).toList());
  }

  Future<CustomUser> getDepartmentManager(Department department) async {
    return _firebaseFirestore
        .collection(Keys.users)
        .where(Keys.id, isEqualTo: department.managerId)
        .get()
        .then((value) => CustomUser.fromMap(value.docs.first.data()));
  }

  Future<void> addEmployeesToDepartments(
    List<CustomUser> employees,
    Department department,
  ) async {
    await _firebaseFirestore
        .collection(Keys.employeesDepartments)
        .where(Keys.department_id, isEqualTo: department.id)
        .get()
        .then((value) async {
      final ids = value.docs.map((element) {
        return element.id;
      });
      for (var id in ids) {
        await _firebaseFirestore
            .collection(Keys.employeesDepartments)
            .doc(id)
            .delete();
      }
    });
    for (var employee in employees) {
      await _firebaseFirestore.collection(Keys.employeesDepartments).add({
        Keys.empId: employee.id,
        Keys.department_id: department.id,
      });
    }
  }

  Future<List<VacationRequest>> getEmployeeVacations(CustomUser user) async {
    return await _firebaseFirestore
        .collection(Keys.vacationsRequests)
        .where(Keys.employeeId, isEqualTo: user.id)
        .get()
        .then((value) =>
            value.docs.map((e) => VacationRequest.fromMap(e.data())).toList());
  }

  Future<List<VacationRequest>> getDepartmentVacations(
      String departmentId) async {
    return await _firebaseFirestore
        .collection(Keys.vacationsRequests)
        .where(Keys.departmentId, isEqualTo: departmentId)
        .get()
        .then((value) =>
            value.docs.map((e) => VacationRequest.fromMap(e.data())).toList());
  }

  Future<void> addVacationRequest(VacationRequest vacationRequest) async {
    vacationRequest.id = await _firebaseFirestore
        .collection(Keys.vacationsRequests)
        .add(vacationRequest.toMap())
        .then((value) => value.id);

    await updateVacation(vacationRequest);
  }

  Future<void> updateVacation(VacationRequest vacationRequest) async {
    await _firebaseFirestore
        .collection(Keys.vacationsRequests)
        .doc(vacationRequest.id)
        .set(vacationRequest.toMap());

    if (vacationRequest.status == RequestStatus.accepted) {
      DateTime dateTime = vacationRequest.dateTimeRange.start;

      do {
        final attendance = Attendance(
          id: DateTime.now().toIso8601String(),
          employeeId: vacationRequest.employeeId,
          employeeName: vacationRequest.employeeName,
          date: dateTime,
          attendanceStatus: AttendanceStatus.vacation,
        );

        await updateAttendance(attendance);
        dateTime = dateTime.add(const Duration(days: 1));
      } while (!dateTime.isAfter(vacationRequest.dateTimeRange.end));
    }
  }

  Future<void> removeEmployeeFromDepartment(
    CustomUser employee,
    Department department,
  ) async {
    final id = await _firebaseFirestore
        .collection(Keys.employeesDepartments)
        .where(Keys.empId, isEqualTo: employee.id)
        .get()
        .then((value) => value.docs.first.id);
    await _firebaseFirestore
        .collection(Keys.employeesDepartments)
        .doc(id)
        .delete();
  }

  Future<List<CustomUser>> getDepartmentEmployees(Department department) async {
    final empsIds = await _firebaseFirestore
        .collection(Keys.employeesDepartments)
        .where(Keys.department_id, isEqualTo: department.id)
        .get()
        .then((value) => value.docs.map((e) => e.data()[Keys.empId]).toList());

    if (empsIds.isEmpty) {
      return <CustomUser>[];
    }
    return _firebaseFirestore
        .collection(Keys.users)
        .where(Keys.id, whereIn: empsIds)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => CustomUser.fromMap(e.data())).toList(),
        );
  }

  Future<String> getDepartmentId(CustomUser manager) async {
    final id = await _firebaseFirestore
        .collection(Keys.departments)
        .where(Keys.managerId, isEqualTo: manager.id)
        .get()
        .then((value) => value.docs.first.data()[Keys.id]);
    return id;
  }

  Future<List<Attendance>> getEmployeeAttendanceHistory(
      CustomUser employee) async {
    return await _firebaseFirestore
        .collection(Keys.attendance)
        .where(Keys.employeeId, isEqualTo: employee.id)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => Attendance.fromMap(e.data())).toList(),
        );
  }

  Future<void> updateAttendance(Attendance attendance) async {
    await _firebaseFirestore
        .collection(Keys.attendance)
        .doc(attendance.id)
        .set(attendance.toMap());
  }

  Future<Attendance?> checkSavedAttendance(CustomUser user) async {
    Attendance? attendance = await _firebaseFirestore
        .collection(Keys.attendance)
        .where(Keys.employeeId, isEqualTo: user.id)
        .get()
        .then(
      (value) {
        if (value.docs.isEmpty) {
          return null;
        }
        final today = value.docs.where((element) {
          final dataTime = DateTime.parse(element[Keys.date]);

          final today = DateTime.now();
          return dataTime.year == today.year &&
              dataTime.month == today.month &&
              dataTime.day == today.day;
        });

        if (today.isEmpty) {
          return null;
        }

        return Attendance.fromMap(today.first.data());
      },
    );

    return attendance;
  }

  Future<bool> checkManagerHasDepartment(CustomUser manager) async {
    return _firebaseFirestore
        .collection(Keys.departments)
        .where(Keys.managerId, isEqualTo: manager.id)
        .get()
        .then((value) => value.docs.isNotEmpty);
  }

  Future<List<Attendance>> allDepartmentEmployeesAttendance(
    CustomUser manager,
  ) async {
    final departmentId = await _firebaseFirestore
        .collection(Keys.departments)
        .where(Keys.managerId, isEqualTo: manager.id)
        .get()
        .then((value) => value.docs.first.data()[Keys.id]);

    final employeesIds = await _firebaseFirestore
        .collection(Keys.employeesDepartments)
        .where(Keys.department_id, isEqualTo: departmentId)
        .get()
        .then((value) => value.docs.map((e) => e.data()[Keys.empId]).toList());

    final attendance = await _firebaseFirestore
        .collection(Keys.attendance)
        .where(Keys.employeeId, whereIn: employeesIds)
        .get()
        .then((value) =>
            value.docs.map((e) => Attendance.fromMap(e.data())).toList());

    return attendance;
  }

  Future<List<CustomUser>> employeesWithoutDepartment(
      Department department) async {
    final employeesWithDepartments = await _firebaseFirestore
        .collection(Keys.employeesDepartments)
        .get()
        .then((value) => value.docs.map((e) => e.data()[Keys.empId]).toList());

    final allEmployees = await employees;

    allEmployees.removeWhere(
        (element) => employeesWithDepartments.contains(element.id));

    return allEmployees;
  }
}
