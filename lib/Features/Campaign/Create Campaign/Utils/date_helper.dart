class DateHelper {
  DateHelper._();

  /// API format: yyyy-MM-dd
  static const String apiFormat = 'yyyy-MM-dd';

  /// Display format: dd MMM yyyy
  static const String displayFormat = 'dd MMM yyyy';

  /// Today at midnight
  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Last day of the current month (e.g. 30 Sep 2025)
  static DateTime get currentMonthLastDate {
    final now = DateTime.now();
    // Day 0 of next month = last day of current month
    return DateTime(now.year, now.month + 1, 0);
  }

  /// Max selectable date = current month ki last date
  static DateTime get maxSelectableDate => currentMonthLastDate;

  /// Format to API string: yyyy-MM-dd
  static String toApiDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Format to display string: dd MMM yyyy
  static String toDisplayDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  /// Check if date is within allowed range (today .. current month last date)
  static bool isSelectable(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(today) && !d.isAfter(maxSelectableDate);
  }

  /// Both dates on same day (helper)
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
