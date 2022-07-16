import 'package:flutter/material.dart';
import 'package:kader/models/meeting.dart';
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

  Future<List<Meeting>> getMeetingsID(String id) async {
    return await firestoreHelper.getMeetingID(id);
  }

  Future<Meeting> getMeetingID(String id) async {
    return await firestoreHelper.getMeeting_ID(id);
  }
}
