import 'package:flutter/material.dart';
import 'package:kader/localization/language/language_ar.dart';
import 'package:kader/localization/language/language_en.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/localization/locale_constant.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      languageList.map((e) => e.languageCode).contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'ar':
        return LanguageAr();
      case 'en':
        return LanguageEn();

      default:
        return LanguageAr();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
