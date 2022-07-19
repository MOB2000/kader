import 'package:flutter/material.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/models/meeting_employee.dart';
import 'package:kader/services/firestore_helper.dart';

class MeetingProvider with ChangeNotifier {
  final FirestoreHelper firestoreHelper = FirestoreHelper.instance;

  Future<List<Meeting>> get meeting async => await firestoreHelper.meeting;

  Future<List<Meeting>> getMeeting(String userId) async {
    return await firestoreHelper.getMeeting(userId);
  }

  Future<void> addMeeting(Meeting meeting) async {
    await firestoreHelper.addMeeting(meeting);
    notifyListeners();
  }

  Future<Meeting> getMeetingById(String id) async {
    return await firestoreHelper.getMeetingById(id);
  }

  Future<void> addMeetingEmployee(MeetingEmployee meetingEmployee) async {
    await firestoreHelper.addMeetingEmployee(meetingEmployee);
    notifyListeners();
  }

  Future<void> updateMeetingEmployee(MeetingEmployee meetingEmployee) async {
    await firestoreHelper.updateMeetingEmployee(meetingEmployee);
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
}
