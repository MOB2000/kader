import 'package:flutter/src/material/time.dart';
import 'package:intl/intl.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/attendance_status.dart';
import 'package:kader/models/request_status.dart';
import 'package:kader/models/user_type.dart';
import 'package:kader/services/shared_preferences_helper.dart';

class StringsHelper {
  StringsHelper._();

  static String get _locale =>
      SharedPreferencesHelper.instance.language.languageCode;

  static String formatDateTime(DateTime dateTime) =>
      DateFormat('dd-MMM-yyyy h:m', _locale).format(dateTime);

  static String getDay(DateTime dateTime) =>
      DateFormat('EEEE', _locale).format(dateTime);

  static String getHourMinute(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  static String getDate(DateTime dateTime) =>
      DateFormat('dd-MMM-yyyy', _locale).format(dateTime);

  static String getDayDate(DateTime dateTime) =>
      DateFormat('EEEE d-MMM-yyyy', _locale).format(dateTime);

  static String getHour(DateTime dateTime) =>
      DateFormat('hh:mm', _locale).format(dateTime);

  static String translateRequestStatus(
    RequestStatus requestStatus,
    Languages languages,
  ) {
    if (requestStatus == RequestStatus.accepted) {
      return languages.accepted;
    }
    if (requestStatus == RequestStatus.rejected) {
      return languages.rejected;
    }
    if (requestStatus == RequestStatus.pending) {
      return languages.pending;
    }

    throw Exception();
  }

  static String translateUserType(
    UserType userType,
    Languages languages,
  ) {
    if (userType == UserType.admin) {
      return languages.admin;
    }
    if (userType == UserType.manager) {
      return languages.manager;
    }
    if (userType == UserType.employee) {
      return languages.employee;
    }

    throw Exception();
  }

  static String translateAttendanceStatus(
    AttendanceStatus attendanceStatus,
    Languages languages,
  ) {
    if (attendanceStatus == AttendanceStatus.attendance) {
      return languages.attendance;
    }
    if (attendanceStatus == AttendanceStatus.absence) {
      return languages.absence;
    }

    if (attendanceStatus == AttendanceStatus.vacation) {
      return languages.vacationSaved;
    }

    throw Exception();
  }
}
