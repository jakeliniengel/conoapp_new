import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:intl/intl.dart';

class DateUtils{
  static final dateFormat =DateFormat("yyyy-MM-dd");

  static String dateToString(DateTime date) => dateFormat.format(date);
}

class DateUtilsBr{
  static final dateFormat =DateFormat("dd/MM/yyyy");

  static String format(DateTime date) => dateFormat.format(date);
}