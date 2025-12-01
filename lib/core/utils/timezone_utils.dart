import 'package:json_annotation/json_annotation.dart';
import 'package:timezone/timezone.dart';
import 'package:intl/intl.dart';

class TZDateTimeConverter implements JsonConverter<TZDateTime?, String?> {
  const TZDateTimeConverter();

  @override
  TZDateTime? fromJson(String? json) {
    if (json == null) return null;
    try {
      final dateTime = DateTime.parse(json);
      return TZDateTime.from(dateTime, UTC);
    } catch (e) {
      return null;
    }
  }

  @override
  String? toJson(TZDateTime? object) {
    if (object == null) return null;
    return object.toUtc().toIso8601String();
  }
}

class TimezoneUtils {
  static String? formatTime(
    TZDateTime? dateTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
    Location? timezone,
  }) {
    if (dateTime == null) return null;

    try {
      final tzDateTime = timezone != null
          ? TZDateTime.from(dateTime, timezone)
          : dateTime;

      final formatter = DateFormat(format);
      return formatter.format(tzDateTime);
    } catch (e) {
      return null;
    }
  }

  static String? formatDateTime(
    DateTime? dateTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
    Location? timezone,
  }) {
    if (dateTime == null) return null;
    return formatTime(
      TZDateTime.from(dateTime, timezone ?? UTC),
      format: format,
    );
  }

  static String? formatTimeWithTimezone(
    TZDateTime? dateTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
    Location? timezone,
  }) {
    if (dateTime == null) return null;

    try {
      final tzDateTime = timezone != null
          ? TZDateTime.from(dateTime, timezone)
          : dateTime;

      final formatter = DateFormat('$format (${tzDateTime.timeZoneName})');
      return formatter.format(tzDateTime);
    } catch (e) {
      return null;
    }
  }

  static String? formatRelativeTime(TZDateTime? dateTime) {
    if (dateTime == null) return null;

    try {
      final now = TZDateTime.now(dateTime.location);
      final difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        return '$days ${days == 1 ? 'day' : 'days'} ago';
      } else {
        return formatTime(dateTime, format: 'MMM dd, yyyy');
      }
    } catch (e) {
      return null;
    }
  }

  static TZDateTime? fromJsonString(String? json, {Location? timezone}) {
    if (json == null) return null;
    try {
      final dateTime = DateTime.parse(json);
      return TZDateTime.from(dateTime, timezone ?? UTC);
    } catch (e) {
      return null;
    }
  }

  static String? toJsonString(TZDateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toUtc().toIso8601String();
  }
}
