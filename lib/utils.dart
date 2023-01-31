import 'package:intl/intl.dart';

String dateToDisplayString(DateTime date) {
  return DateFormat.yMd().format(date);
}
