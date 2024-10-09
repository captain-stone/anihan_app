import 'package:intl/intl.dart';

class DateServices {
  String dateNow() {
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('MM-dd-yyyy h:mma').format(now).toLowerCase();

    return formattedDate;
  }
}
