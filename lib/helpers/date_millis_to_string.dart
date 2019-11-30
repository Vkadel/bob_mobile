import 'package:intl/intl.dart';

class DateMillisToString {
  int dateInMills;
  String dateString;

  DateMillisToString(this.dateInMills);

  String getDateString() {
    if (dateInMills != null) {
      var formatter = new DateFormat('MM-dd-yyyy');
      DateTime date = DateTime.fromMillisecondsSinceEpoch(dateInMills);
      return dateString = formatter.format(date);
    } else {
      return 'No date';
    }
  }
}
