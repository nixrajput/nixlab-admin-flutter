import 'package:intl/intl.dart';

String dateTime(timestamp) {
  DateTime _dateTime = timestamp.toDate();
  var _formatDate = DateFormat.yMMMd().format(_dateTime);
  return _formatDate;
}
