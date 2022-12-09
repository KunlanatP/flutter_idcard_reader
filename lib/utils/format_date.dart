import 'package:intl/intl.dart';

String formattedDateEN(String dt) {
  try {
    DateTime dateTime = DateTime.parse(dt);
    String formattedDate = DateFormat('dd MMM yyyy', 'en_US').format(dateTime);
    return formattedDate;
  } catch (e) {
    return dt.split('').toString() + e.toString();
  }
}

String formattedDateTH(String dt) {
  try {
    final yearEN = dt.substring(0, 4);
    final month = dt.substring(5, 7);
    final date = dt.substring(8, 10);
    final yearTH = int.parse(yearEN) + 543;
    DateTime dateTime = DateTime.parse('$yearTH-$month-$date');
    String formattedDate = DateFormat.yMMMd('th_TH').format(dateTime);
    return formattedDate;
  } catch (e) {
    return dt.split('').toString() + e.toString();
  }
}
