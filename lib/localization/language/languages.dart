import 'package:flutter/material.dart';

abstract class Languages {
  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages)!;
  }

  String get languageCode;

  String get kader;

  String get appLanguage;

  String get home;

  String get login;

  String get register;

  String get name;

  String get email;

  String get password;

  String get phoneNumber;

  String get idNumber;

  String get photo;

  String get gender;

  String get male;

  String get female;

  String get posts;

  String get complaints;

  String get lastLogin;

  String get logout;

  String get signingIn;

  String get noInternetConnection;

  String get noPosts;

  String get no;

  String get yes;

  String get noMorePosts;

  String get search;

  String get close;

  String get attendance;

  String get leaving;

  String get manager;

  String get noManagersFound;

  String get errorOccurred;

  String get areYouSure;

  String get details;

  String get accept;

  String get reject;

  String get promotion;

  String get downgrade;

  String get managerMustRemovedFromDepartment;

  String get noResults;

  String get postDetails;

  String get enterValue;

  String get mohStaff;

  String get clickHereToGoToThePostPage;

  String get sharePost;

  String get custody;

  String get profile;

  String get vacations;

  String get manageDepartment;

  String get manageDepartments;

  String get manageStaff;

  String get departments;

  String get meetings;

  String get transitionsRequests;

  String get kDisplayVacations;

  String get vacationLength;

  String get startDate;

  String get returnDate;

  String get attendanceHistory;

  String get noData;

  String get absenceSaved;

  String get checkAttendance;

  String get checkLeaving;

  String get checkAbsence;

  String get showHistory;

  String get requestVacation;

  String get staffManagement;

  String get sendRequest;

  String get cause;

  String get pickDuration;

  String get duration;

  String get cancel;

  String get done;

  String get noEmployeesInTheDepartment;

  String get addRemoveEmployees;

  String get employees;

  String get departmentDetails;

  String get mustChooseManager;

  String get create;

  String get departmentName;

  String get createDepartment;

  String get mustPickAPicture;

  String get pickPicture;

  String get phoneNumberMustBeTen;

  String get idNumberMustBeTen;

  String get alreadyHaveAccountLogin;
}
