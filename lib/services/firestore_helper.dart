import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kader/constants/keys.dart';
import 'package:kader/models/attendance.dart';
import 'package:kader/models/attendance_status.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/models/custody_transfer_request.dart';
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
    await _firebaseFirestore.collection(Keys.vacationsBalance).add({
      Keys.userId: user.id,
      Keys.balance: Keys.vacationBalanceForYear,
    });
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

  Future<void> addEmployeesToDepartment(
    List<CustomUser> employees,
    Department department,
  ) async {
    await _firebaseFirestore
        .collection(Keys.employeesDepartments)
        .where(Keys.departmentId, isEqualTo: department.id)
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
        Keys.employeeId: employee.id,
        Keys.departmentId: department.id,
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
      Department department) async {
    return await _firebaseFirestore
        .collection(Keys.vacationsRequests)
        .where(Keys.departmentId, isEqualTo: department.id)
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
      final length = vacationRequest.dateTimeRange.duration.inDays;

      final vacationsBalance = await FirebaseFirestore.instance
          .collection(Keys.vacationsBalance)
          .where(Keys.userId, isEqualTo: vacationRequest.employeeId)
          .get()
          .then((value) => value.docs.first.data()[Keys.balance]);

      final docId = await _firebaseFirestore
          .collection(Keys.vacationsBalance)
          .where(Keys.userId, isEqualTo: vacationRequest.employeeId)
          .get()
          .then((value) => value.docs.first.id);

      await _firebaseFirestore
          .collection(Keys.vacationsBalance)
          .doc(docId)
          .set({
        Keys.userId: vacationRequest.employeeId,
        Keys.balance: vacationsBalance - length,
      });

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
        .where(Keys.employeeId, isEqualTo: employee.id)
        .get()
        .then((value) => value.docs.first.id);
    await _firebaseFirestore
        .collection(Keys.employeesDepartments)
        .doc(id)
        .delete();
  }

  Future<List<CustomUser>> getDepartmentEmployees(Department department) async {
    final employeesIds = await _firebaseFirestore
        .collection(Keys.employeesDepartments)
        .where(Keys.departmentId, isEqualTo: department.id)
        .get()
        .then((value) =>
            value.docs.map((e) => e.data()[Keys.employeeId]).toList());

    if (employeesIds.isEmpty) {
      return <CustomUser>[];
    }
    return _firebaseFirestore
        .collection(Keys.users)
        .where(Keys.id, whereIn: employeesIds)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => CustomUser.fromMap(e.data())).toList(),
        );
  }

  Future<Department> getDepartmentByEmployee(CustomUser employee) async {
    final id = await _firebaseFirestore
        .collection(Keys.employeesDepartments)
        .where(Keys.employeeId, isEqualTo: employee.id)
        .get()
        .then((value) => value.docs.first.data()[Keys.departmentId]);

    final department = await _firebaseFirestore
        .collection(Keys.departments)
        .where(Keys.id, isEqualTo: id)
        .get()
        .then((value) => Department.fromMap(value.docs.first.data()));
    return department;
  }

  Future<Department> getDepartmentByManager(CustomUser manager) async {
    final id = await _firebaseFirestore
        .collection(Keys.departments)
        .where(Keys.managerId, isEqualTo: manager.id)
        .get()
        .then((value) => value.docs.first.data()[Keys.id]);
    final department = await _firebaseFirestore
        .collection(Keys.departments)
        .where(Keys.id, isEqualTo: id)
        .get()
        .then((value) => Department.fromMap(value.docs.first.data()));
    return department;
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
        .where(Keys.departmentId, isEqualTo: departmentId)
        .get()
        .then((value) =>
            value.docs.map((e) => e.data()[Keys.employeeId]).toList());

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
        .then((value) =>
            value.docs.map((e) => e.data()[Keys.employeeId]).toList());

    final allEmployees = await employees;

    allEmployees.removeWhere(
        (element) => employeesWithDepartments.contains(element.id));

    return allEmployees;
  }

  Future<Department> getDepartmentById(String id) async {
    return _firebaseFirestore
        .collection(Keys.departments)
        .where(Keys.id, isEqualTo: id)
        .get()
        .then((value) => Department.fromMap(value.docs.first.data()));
  }

  Future<Department> getDepartmentByManagerId(String managerId) async {
    return _firebaseFirestore
        .collection(Keys.departments)
        .where(Keys.managerId, isEqualTo: managerId)
        .get()
        .then((value) => Department.fromMap(value.docs.first.data()));
  }

  Future<List<Complaint>> get complaints async =>
      await _firebaseFirestore.collection(Keys.complaints).get().then((value) =>
          value.docs.map((e) => Complaint.fromMap(e.data())).toList());

  Future<void> addComplaint(Complaint complaint) async {
    complaint.id = await _firebaseFirestore
        .collection(Keys.complaints)
        .add(complaint.toMap())
        .then((value) => value.id);
    await updateComplaint(complaint);
  }

  Future<List<Complaint>> getComplaints(String ownerId) async {
    final complaints = await _firebaseFirestore
        .collection(Keys.complaints)
        .where(Keys.ownerId, isEqualTo: ownerId)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => Complaint.fromMap(e.data())).toList(),
        );
    return complaints;
  }

  Future<void> updateComplaint(Complaint complaint) async {
    await _firebaseFirestore
        .collection(Keys.complaints)
        .doc(complaint.id)
        .set(complaint.toMap());
  }

  Future<void> addCustody(Custody custody) async {
    custody.id = await _firebaseFirestore
        .collection(Keys.custodies)
        .add(custody.toMap())
        .then((value) => value.id);
    await updateCustody(custody);
  }

  Future<void> updateCustody(Custody custody) async {
    await _firebaseFirestore
        .collection(Keys.custodies)
        .doc(custody.id)
        .set(custody.toMap());
  }

  Future<List<Custody>> getUserCustodies(CustomUser user) async {
    return await _firebaseFirestore
        .collection(Keys.custodies)
        .where(Keys.ownerId, isEqualTo: user.id)
        .get()
        .then((value) =>
            value.docs.map((e) => Custody.fromMap(e.data())).toList());
  }

  Future<List<Custody>> get custodiesWithReply async => await _firebaseFirestore
      .collection(Keys.custodies)
      .where(Keys.reply, isEqualTo: true)
      .get()
      .then(
          (value) => value.docs.map((e) => Custody.fromMap(e.data())).toList());

  Future<List<Custody>> get custodiesWithoutReply async =>
      await _firebaseFirestore
          .collection(Keys.custodies)
          .where(Keys.reply, isNotEqualTo: true)
          .get()
          .then((value) =>
              value.docs.map((e) => Custody.fromMap(e.data())).toList());

  Future<List<Custody>> getCustodyByOwnerId(String ownerId) async {
    final custodies = await _firebaseFirestore
        .collection(Keys.custodies)
        .where(Keys.ownerId, isEqualTo: ownerId)
        .get()
        .then(
          (value) => value.docs.map((e) => Custody.fromMap(e.data())).toList(),
        );
    return custodies;
  }

  Future<void> deleteCustody(Custody custody) async {
    await _firebaseFirestore
        .collection(Keys.custodies)
        .doc(custody.id)
        .delete();
  }

  Future<void> addMeeting(Meeting meeting) async {
    meeting.id = await _firebaseFirestore
        .collection(Keys.meeting)
        .add(meeting.toMap())
        .then((value) => value.id);
    await updateMeeting(meeting);
  }

  Future<void> updateMeeting(Meeting meeting) async {
    await _firebaseFirestore
        .collection(Keys.meeting)
        .doc(meeting.id)
        .set(meeting.toMap());
  }

  Future<List<Meeting>> get meeting async =>
      await _firebaseFirestore.collection(Keys.meeting).get().then(
          (value) => value.docs.map((e) => Meeting.fromMap(e.data())).toList());

  Future<List<Meeting>> getMeeting(String id) async {
    final meeting = await _firebaseFirestore
        .collection(Keys.meeting)
        .where(Keys.ownerId, isEqualTo: id)
        .get()
        .then(
          (value) => value.docs.map((e) => Meeting.fromMap(e.data())).toList(),
        );
    return meeting;
  }

  Future<Meeting> getMeetingById(String id) async {
    return _firebaseFirestore
        .collection(Keys.meeting)
        .where(Keys.id, isEqualTo: id)
        .get()
        .then((value) => Meeting.fromMap(value.docs.first.data()));
  }

  Future<void> addMeetingEmployee(MeetingEmployee meetingEmployee) async {
    meetingEmployee.id = await _firebaseFirestore
        .collection(Keys.meetingEmployee)
        .add(meetingEmployee.toMap())
        .then((value) => value.id);
    await updateMeetingEmployee(meetingEmployee);
  }

  Future<void> updateMeetingEmployee(MeetingEmployee meetingEmployee) async {
    await _firebaseFirestore
        .collection(Keys.meetingEmployee)
        .doc(meetingEmployee.id)
        .set(meetingEmployee.toMap());
  }

  Future<void> deleteMeetingEmployee(MeetingEmployee meetingEmployee) async {
    await _firebaseFirestore
        .collection(Keys.meetingEmployee)
        .doc(meetingEmployee.id)
        .delete();
  }

  Future<bool> checkExisting(String ownerId, String meetId) async {
    final result = await _firebaseFirestore
        .collection(Keys.meetingEmployee)
        .where(Keys.ownerId, isEqualTo: ownerId)
        .where(Keys.meetId, isEqualTo: meetId)
        .get();
    return result.size != 0;
  }

  Future<List<MeetingEmployee>> getMeetingEmployee(String id) async {
    final meetingEmployee = await _firebaseFirestore
        .collection(Keys.meetingEmployee)
        .where(Keys.meetId, isEqualTo: id)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => MeetingEmployee.fromMap(e.data())).toList(),
        );
    return meetingEmployee;
  }

  Future<List<MeetingEmployee>> getMeetingAllEmployee(String ownerId) async {
    final result = await _firebaseFirestore
        .collection(Keys.meetingEmployee)
        .where(Keys.ownerId, isEqualTo: ownerId)
        .get()
        .then((value) =>
            value.docs.map((e) => MeetingEmployee.fromMap(e.data())).toList());
    return result;
  }

  Future<void> deleteCustodyTransferRequest(
    CustodyTransferRequest request,
  ) async {
    final requestCustody = await custodiesWithReply.then((value) =>
        value.where((element) => request.custodyId == element.id).first);
    requestCustody.hasRequestToTransfer = false;
    await updateCustody(requestCustody);

    await _firebaseFirestore
        .collection(Keys.custodyTransferRequest)
        .doc(request.id)
        .delete();
  }

  Future<void> addCustodyTransferRequest(CustodyTransferRequest request) async {
    request.id = await _firebaseFirestore
        .collection(Keys.custodyTransferRequest)
        .add(request.toMap())
        .then((value) => value.id);
    await updateCustodyTransferRequest(request);
  }

  Future<List<CustodyTransferRequest>> get custodyTransferRequests =>
      _firebaseFirestore.collection(Keys.custodyTransferRequest).get().then(
          (value) => value.docs
              .map((e) => CustodyTransferRequest.fromMap(e.data()))
              .toList());

  Future<void> updateCustodyTransferRequest(
    CustodyTransferRequest request,
  ) async {
    await _firebaseFirestore
        .collection(Keys.custodyTransferRequest)
        .doc(request.id)
        .set(request.toMap());
  }

  Future<void> transferCustody(CustodyTransferRequest request) async {
    final custody = await _firebaseFirestore
        .collection(Keys.custodies)
        .doc(request.custodyId)
        .get()
        .then((value) => Custody.fromMap(value.data()!));
    custody.ownerId = request.toUserId;
    custody.ownerName = request.toUserName;
    await updateCustody(custody);
    await deleteCustodyTransferRequest(request);
  }
}
