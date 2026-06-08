import 'package:intl/intl.dart';

class PopupDateTimeUtils {
  PopupDateTimeUtils._();

  static final DateFormat _displayFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  static DateTime? parseApiValue(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }

  static String format(DateTime? value) {
    return value == null ? '' : _displayFormat.format(value);
  }

  static String? toApiValue(DateTime? value) {
    return value?.toUtc().toIso8601String();
  }
}
