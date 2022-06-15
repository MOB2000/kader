import 'package:intl/intl.dart';
import 'package:kader/services/shared_preferences_helper.dart';

class StringsHelper {
  StringsHelper._();

  //_locale = Languages.of(context) .languageCode

  static String get _locale =>
      SharedPreferencesHelper.instance.language.languageCode;

  static String formatDateTime(DateTime dateTime) =>
      DateFormat('dd-MMM-yyyy h:m', _locale).format(dateTime);

  static String getDay(DateTime dateTime) =>
      DateFormat('EEEE', _locale).format(dateTime);

  static String getDate(DateTime dateTime) =>
      DateFormat('dd-MMM-yyyy', _locale).format(dateTime);

  static String getDayDate(DateTime dateTime) =>
      DateFormat('EEEE d-MMM-yyyy', _locale).format(dateTime);
}
