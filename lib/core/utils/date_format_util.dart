

import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/logger/app_logger.dart';

/// Shortcut for DateFormatUtil [DFU]
typedef DFU = DateFormatUtil;

abstract class _DateTimeFormats {
  static final dayName = DateFormat('EEE');
  static final dayNameFull = DateFormat('EEEE');
  static final ddMMyyyy = DateFormat('dd-MM-yyyy');
  static final ddMMMyyyy = DateFormat('dd-MMM-yyyy');
  static final friendlyFormat = DateFormat('dd/MMM/yyyy');
  static final toYYYYmmDDHHmmss = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final ddMMyyyyHHmmss = DateFormat('dd-MM-yyyy HH:mm:ss');
  static final hhmmss = DateFormat('HH:mm:ss');
}
abstract class DateFormatUtil {
  static DateTime now() => DateTime.now();

  static String getDayName(DateTime dateTime) => _DateTimeFormats.dayName.format(dateTime);

  static String getDayNameFully(DateTime dateTime) => _DateTimeFormats.dayNameFull.format(dateTime);
  static String ddMMyyyy(DateTime dateTime) => _DateTimeFormats.ddMMyyyy.format(dateTime);
  static String ddMMMyyyy(DateTime dateTime) => _DateTimeFormats.ddMMMyyyy.format(dateTime);
  static String friendlyFormat(DateTime dateTime) => _DateTimeFormats.friendlyFormat.format(dateTime);
  static String hhmmss(DateTime dateTime) => _DateTimeFormats.hhmmss.format(dateTime);
  static String ddMMyyyyHHmmss(DateTime dateTime) => _DateTimeFormats.ddMMyyyyHHmmss.format(dateTime);

  static String fromFrappeToddMMyyyy(String? dateTime) {
    if(dateTime == null) return '';
    try {
      final dObj= DateTime.parse(dateTime);
      return _DateTimeFormats.ddMMMyyyy.format(dObj);
    } catch (e) {
      return '';
    }
  }
  
  static DateTime toDateTIme(String date, [String format = 'yyyy-MM-dd']) => DateFormat(format).parse(date);
  
  static String? toYYYYmmDDHHmmss(String? date, String? time) {
    if(date ==null || time == null) return null;
    try {  
      final datetime = _DateTimeFormats.ddMMyyyyHHmmss.parse('$date $time');
      return _DateTimeFormats.toYYYYmmDDHHmmss.format(datetime);
    } on Exception catch (e, st) {
      $logger.error('[toYYYYmmDDHHmmss]', e, st);
    }
    return null;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
