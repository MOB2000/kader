import 'dart:convert';

import 'package:kader/constants/keys.dart';
import 'package:kader/localization/language_data.dart';
import 'package:kader/localization/locale_constant.dart';
import 'package:kader/models/custom_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._();

  static final SharedPreferencesHelper instance = SharedPreferencesHelper._();

  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setIsLogged(bool isLogged) async {
    await _sharedPreferences.setBool(Keys.isLogged, isLogged);
  }

  bool get isLogged => _sharedPreferences.getBool(Keys.isLogged) ?? false;

  Future<void> setUser(CustomUser account) async {
    await _sharedPreferences.setString(
        Keys.account, jsonEncode(account.toMap()));
  }

  CustomUser get account {
    final map = jsonDecode(_sharedPreferences.getString(Keys.account)!);
    return CustomUser.fromMap(map);
  }

  Future<void> setLanguage(LanguageData languageData) async {
    await _sharedPreferences.setString(
        Keys.selectedLanguage, jsonEncode(languageData.toMap()));
  }

  LanguageData get language {
    final mapString = _sharedPreferences.getString(Keys.selectedLanguage);
    if (mapString == null) {
      return languageList.first;
    }

    return LanguageData.fromMap(jsonDecode(mapString) as Map<String, dynamic>);
  }
}
