import 'package:flutter/material.dart';
import 'package:kader/constants/keys.dart';

class LanguageData {
  final String name;
  final String languageCode;

  const LanguageData(this.name, this.languageCode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageData &&
          runtimeType == other.runtimeType &&
          languageCode == other.languageCode;

  @override
  int get hashCode => languageCode.hashCode;

  Locale get toLocale => Locale(languageCode, '');

  factory LanguageData.fromMap(Map<String, dynamic> map) {
    return LanguageData(
      map[Keys.name],
      map[Keys.languageCode],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.name: name,
      Keys.languageCode: languageCode,
    };
  }
}
