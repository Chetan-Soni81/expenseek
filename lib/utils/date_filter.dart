import 'package:intl/intl.dart';

/// Date filter types
enum DateFilterType {
  today,
  thisWeek,
  thisMonth,
  thisYear,
  allTime,
  custom,
}

/// Date filter utility class
class DateFilter {
  final DateFilterType type;
  final DateTime? startDate;
  final DateTime? endDate;

  DateFilter({
    required this.type,
    this.startDate,
    this.endDate,
  });

  /// Get SQL WHERE clause for date filtering
  String getDateWhereClause({String? alias}) {
    final a = alias != null && alias.isNotEmpty ? "$alias." : "";
    switch (type) {
      case DateFilterType.today:
        return "strftime('%Y-%m-%d', ${a}createdAt) = date('now', 'localtime')";
      
      case DateFilterType.thisWeek:
        return "strftime('%Y-%m-%d', ${a}createdAt) BETWEEN date('now', 'weekday 0', '-7 days') AND date('now', 'weekday 0')";
      
      case DateFilterType.thisMonth:
        return "strftime('%Y-%m', ${a}createdAt) = strftime('%Y-%m', 'now')";
      
      case DateFilterType.thisYear:
        return "strftime('%Y', ${a}createdAt) = strftime('%Y', 'now')";
      
      case DateFilterType.allTime:
        return "1=1"; // Always true
      
      case DateFilterType.custom:
        if (startDate != null && endDate != null) {
          final startStr = DateFormat('yyyy-MM-dd').format(startDate!);
          final endStr = DateFormat('yyyy-MM-dd').format(endDate!);
          return "strftime('%Y-%m-%d',${a}createdAt) BETWEEN '$startStr' AND '$endStr'";
        }
        return "1=1";
    }
  }

  /// Get display name for the filter
  String getDisplayName() {
    switch (type) {
      case DateFilterType.today:
        return 'Today';
      case DateFilterType.thisWeek:
        return 'This Week';
      case DateFilterType.thisMonth:
        return 'This Month';
      case DateFilterType.thisYear:
        return 'This Year';
      case DateFilterType.allTime:
        return 'All Time';
      case DateFilterType.custom:
        if (startDate != null && endDate != null) {
          return '${DateFormat('MMM dd').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}';
        }
        return 'Custom';
    }
  }
}

