import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Map<String, dynamic> setDateTimeFromTimestamp(String dateTimeString) {
  DateTime parsedDateTime;
  try {
    parsedDateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(dateTimeString);
    final parsedDate = DateTime(
      parsedDateTime.year,
      parsedDateTime.month,
      parsedDateTime.day,
    );

    final parsedTime = TimeOfDay(
      hour: parsedDateTime.hour,
      minute: parsedDateTime.minute,
    );
    return {'date': parsedDate, 'time': parsedTime};
  } catch (e) {
    return {'date': DateTime.now(), 'time': TimeOfDay.now()};
  }
}

String? convertDateTimeToReadableString(DateTime? dateTime) {
  if (dateTime != null) {
    final String formattedDateTime =
        DateFormat("dd/MM/yyyy").format(dateTime);
    return formattedDateTime;
  } else {
    return null;
  }
}

String? convertTimeDayToReadableString(BuildContext context, TimeOfDay? timeOfDay) {
  if (timeOfDay != null) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    // Formats the TimeOfDay to a string based on the current locale.
    String formattedTime =
        localizations.formatTimeOfDay(timeOfDay, alwaysUse24HourFormat: false);
    return formattedTime;
  } else {
    return null;
  }
}

String? combineDateAndTime(DateTime? date, TimeOfDay? time) {
  if (date != null && time != null) {
    final DateTime combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final String formattedDateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(combinedDateTime);

    return formattedDateTime;
    // Use this combinedDateTime or formattedDateTime for your purpose
  } else {
    return null;
  }
}
