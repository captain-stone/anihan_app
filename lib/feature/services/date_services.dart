import 'package:intl/intl.dart';

class DateServices {
  final DateTime now = DateTime.now();

  String dateNow() {
    String formattedDate =
        DateFormat('MM-dd-yyyy h:mma').format(now).toLowerCase();

    return formattedDate;
  }

  int dateNowMillis() {
    int millis = now.millisecondsSinceEpoch;
    return millis;
  }

  String dateMillistToDate(int dateMillis) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateMillis);

    String formattedDate =
        DateFormat('MM-dd-yyyy h:mma').format(date).toLowerCase();
    return formattedDate;
  }
}
