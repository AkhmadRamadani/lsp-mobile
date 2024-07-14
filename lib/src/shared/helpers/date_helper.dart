class DateHelper {
  DateHelper._();

  static final _ammountDays = [
    0,
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31,
  ];

  /// Returns the number of days in the given month.
  /// For example, if the month is February, the number of days is 28.
  /// If the month is March, the number of days is 31.
  /// If the month is April, the number of days is 30.
  static int daysInMonth(int year, int month) =>
      (month == DateTime.february && isLeapYear(year))
          ? 29
          : _ammountDays[month];

  /// Returns true if the given year is a leap year.
  static bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
}
