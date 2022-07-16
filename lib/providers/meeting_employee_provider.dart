import 'package:flutter/cupertino.dart';
import 'package:kader/models/meeting_employee.dart';
import 'package:kader/services/firestore_helper.dart';

class MeetingEmployeeProvider with ChangeNotifier {
  final FirestoreHelper firestoreHelper = FirestoreHelper.instance;

  Future<void> addMeetingEmployee(MeetingEmployee meetingEmployee) async {
    await firestoreHelper.addMeetingEmployee(meetingEmployee);
    notifyListeners();
  }

  Future<bool> checkExisting(String ownerId, String meetId) async {
    return await firestoreHelper.checkExisting(ownerId, meetId);
  }

  Future<List<MeetingEmployee>> getMeetingEmployee(String id) async {
    return await firestoreHelper.getMeetingEmployee(id);
  }

  Future<List<MeetingEmployee>> getEmployeeMeetings(String id) async {
    return await firestoreHelper.getMeetingAllEmployee(id);
  }

  Future<void> updateMeetingEmployee(MeetingEmployee meetingEmployee) async {
    await firestoreHelper.updateMeetingEmployee_reply(meetingEmployee);
    print(meetingEmployee.reply);
    notifyListeners();
  }
}
