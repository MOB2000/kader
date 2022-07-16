import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kader/constants/keys.dart';
import 'package:kader/models/attendance.dart';
import 'package:kader/models/attendance_status.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/department.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/models/meeting_employee.dart';
import 'package:kader/models/request_status.dart';
import 'package:kader/models/vacation_request.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper instance = FirestoreHelper._();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(CustomUser user) async {
    await _firebaseFirestore.collection(Keys.users).add(user.toMap());
  }

  Future<Department> getDepartmentID(String id) async {
    final doc = await _firebaseFirestore
        .collection('departments')
        .where('id', isEqualTo: id)
        .get()
        .then((value) => value.docs.first);
    return Department.fromMap(doc.data().cast());
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

  Future<Department> getDepartment(String id) async {
    return _firebaseFirestore
        .collection('departments')
        .where('manager_id', isEqualTo: id)
        .get()
        .then((value) => Department.fromMap(value.docs.first.data()));
  }

  Future<void> addComplaint(Complaint complaint) async {
    complaint.id = await _firebaseFirestore
        .collection('complaints')
        .add(complaint.toMap())
        .then((value) => value.id);
    await updateComplaints_ID(complaint);
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

  Future<void> updateComplaints_ID(Complaint complaint) async {
    await _firebaseFirestore
        .collection('complaints')
        .doc(complaint.id)
        .set(complaint.toMap());
  }

  Future<void> updateComplaints_reply(Complaint complaint) async {
    await _firebaseFirestore
        .collection('complaints')
        .doc(complaint.id)
        .update(complaint.toMap());
  }

  Future<void> deleteComplaints() async {
    var collection = await _firebaseFirestore.collection('complaints');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> addCustody(Custody custody) async {
    custody.id = await _firebaseFirestore
        .collection('custodys')
        .add(custody.toMap())
        .then((value) => value.id);
    await updateCustody_ID(custody);
  }

  Future<void> updateCustody_ID(Custody custody) async {
    await _firebaseFirestore
        .collection('custodys')
        .doc(custody.id)
        .set(custody.toMap());
  }

  Future<void> updateCustody_reply(Custody custody) async {
    await _firebaseFirestore
        .collection('custodys')
        .doc(custody.id)
        .update(custody.toMap());
  }

  Future<List<Custody>> get custody async =>
      await _firebaseFirestore.collection('custodys').get().then(
          (value) => value.docs.map((e) => Custody.fromMap(e.data())).toList());

  Future<List<Custody>> get custodiesWithoutReply async =>
      await _firebaseFirestore
          .collection('custodys')
          .where('reply', isNotEqualTo: true)
          .get()
          .then((value) =>
              value.docs.map((e) => Custody.fromMap(e.data())).toList());

  Future<List<Custody>> getCustody(String ownerId) async {
    final custodys = await _firebaseFirestore
        .collection('custodys')
        .where('ownerId', isEqualTo: ownerId)
        .get()
        .then(
          (value) => value.docs.map((e) => Custody.fromMap(e.data())).toList(),
        );
    return custodys;
  }

  Future<void> deleteCustody(Custody custody) async {
    await _firebaseFirestore.collection('custodys').doc(custody.id).delete();
  }

  Future<void> addMeeting(Meeting meeting) async {
    meeting.id = await _firebaseFirestore
        .collection('meeting')
        .add(meeting.toMap())
        .then((value) => value.id);
    await updateMeeting_ID(meeting);
  }

  Future<void> updateMeeting_ID(Meeting meeting) async {
    await _firebaseFirestore
        .collection('meeting')
        .doc(meeting.id)
        .set(meeting.toMap());
  }

  Future<List<Meeting>> get meeting async =>
      await _firebaseFirestore.collection('meeting').get().then(
          (value) => value.docs.map((e) => Meeting.fromMap(e.data())).toList());

  Future<List<Meeting>> getMeeting(String id) async {
    final meeting = await _firebaseFirestore
        .collection('meeting')
        .where('ownerId', isEqualTo: id)
        .get()
        .then(
          (value) => value.docs.map((e) => Meeting.fromMap(e.data())).toList(),
        );
    return meeting;
  }

  Future<List<Meeting>> getMeetingID(String id) async {
    final meeting = await _firebaseFirestore
        .collection('meeting')
        .where('ID', isEqualTo: id)
        .get()
        .then(
          (value) => value.docs.map((e) => Meeting.fromMap(e.data())).toList(),
        );
    return meeting;
  }

  Future<Meeting> getMeeting_ID(String id) async {
    return _firebaseFirestore
        .collection('meeting')
        .where('ID', isEqualTo: id)
        .get()
        .then((value) => Meeting.fromMap(value.docs.first.data()));
  }

  Future<void> addMeetingEmployee(MeetingEmployee meetingEmployee) async {
    meetingEmployee.id = await _firebaseFirestore
        .collection('meetingEmployee')
        .add(meetingEmployee.toMap())
        .then((value) => value.id);
    await updateMeetingEmployee_ID(meetingEmployee);
  }

  Future<void> updateMeetingEmployee_ID(MeetingEmployee meetingEmployee) async {
    await _firebaseFirestore
        .collection('meetingEmployee')
        .doc(meetingEmployee.id)
        .set(meetingEmployee.toMap());
  }

  Future<void> deleteMeetingEmployee(MeetingEmployee meetingEmployee) async {
    await _firebaseFirestore
        .collection('meetingEmployee')
        .doc(meetingEmployee.id)
        .delete();
  }

  Future<void> updateMeetingEmployee_reply(
      MeetingEmployee meetingEmployee) async {
    await _firebaseFirestore
        .collection('meetingEmployee')
        .doc(meetingEmployee.id)
        .update(meetingEmployee.toMap());
  }

  Future<bool> checkExisting(String ownerId, String meetId) async {
    final result = await _firebaseFirestore
        .collection('meetingEmployee')
        .where("ownerId", isEqualTo: ownerId)
        .where("meetID", isEqualTo: meetId)
        .get();
    return result.size != 0;
  }

  Future<List<MeetingEmployee>> getMeetingEmployee(String id) async {
    final meetingEmployee = await _firebaseFirestore
        .collection('meetingEmployee')
        .where('meetID', isEqualTo: id)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => MeetingEmployee.fromMap(e.data())).toList(),
        );
    return meetingEmployee;
  }

  Future<List<MeetingEmployee>> getMeetingAllEmployee(String ownerId) async {
    final result = await _firebaseFirestore
        .collection('meetingEmployee')
        .where("ownerId", isEqualTo: ownerId)
        .get()
        .then((value) =>
            value.docs.map((e) => MeetingEmployee.fromMap(e.data())).toList());
    print(result.length);
    return result;
  }
}
