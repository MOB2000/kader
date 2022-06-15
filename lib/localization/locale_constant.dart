import 'package:flutter/material.dart';
import 'package:kader/localization/language_data.dart';
import 'package:kader/main.dart';
import 'package:kader/services/shared_preferences_helper.dart';

const languageList = <LanguageData>[
  LanguageData('العربية', 'ar'),
  LanguageData("English", 'en'),
];

Future<void> changeLanguage(
  BuildContext context,
  LanguageData languageData,
) async {
  final locale = await saveLocale(languageData);
  Kader.setLocale(context, locale);
}

Future<Locale> saveLocale(LanguageData languageData) async {
  await SharedPreferencesHelper.instance.setLanguage(languageData);
  return languageData.toLocale;
}

Locale getLocale() {
  return SharedPreferencesHelper.instance.language.toLocale;
}
