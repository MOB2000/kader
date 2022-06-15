import 'package:intl/intl.dart';

class StringsHelper {
  StringsHelper._();

  static String formatDateTime(DateTime dateTime, String locale) =>
      DateFormat('dd-MMM-yyyy h:m', locale).format(dateTime);

  static String getDay(DateTime dateTime, String locale) =>
      DateFormat('EEEE', locale).format(dateTime);

  static String getDate(DateTime dateTime, String locale) =>
      DateFormat('dd-MMM-yyyy', locale).format(dateTime);

  static String getDayDate(DateTime dateTime, String locale) =>
      DateFormat('EEEE d-MMM-yyyy', locale).format(dateTime);
}
