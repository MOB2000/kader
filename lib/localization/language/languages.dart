import 'package:flutter/material.dart';

abstract class Languages {
  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages)!;
  }

  String get languageCode;
  String get kader;
  String get appLanguage;
  String get kHome;
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
  String get noMorePosts;
  String get search;
  String get close;
  String get vacationsBalance;
  String get errorOccurred;
  String get noResults;
  String get postDetails;
  String get enterValue;
  String get mohStaff;
  String get clickHereToGoToThePostPage;
  String get sharePost;
  String get custody;
  String get profile;
  String get eVacation;
  String get manageDepartment;
  String get meetings;
  String get transitionsRequests;
  String get workingHours;
  String get vacationRequest;
  String get pendingRequests;
  String get returnAcknowledgment;
  String get kDisplayVacations;
  String get vacationLength;
  String get enterVacationDaysNumber;
  String get digitsOnlyAllowed;
  String get startDate;
  String get returnDate;
  String get requestVacation;
}
