import 'package:flutter/material.dart';
import 'package:kader/constants/keys.dart';
import 'package:time_range_picker/time_range_picker.dart';

class Meeting {
  String? id;
  final DateTime date;
  final TimeRange time;
  final String place;
  final String subject;
  final String ownerId;
  final String departmentId;

  Meeting({
    this.id,
    required this.date,
    required this.time,
    required this.place,
    required this.subject,
    required this.ownerId,
    required this.departmentId,
  });

  Meeting.fromMap(Map<String, dynamic> map)
      : date = DateTime.parse(map[Keys.date]),
        subject = map[Keys.subject],
        place = map[Keys.place],
        time = CustomTimeRange.fromMap(map[Keys.time]).time,
        departmentId = map[Keys.departmentId],
        ownerId = map[Keys.ownerId],
        id = map[Keys.id];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.date: date.toIso8601String(),
      Keys.subject: subject,
      Keys.place: place,
      Keys.time: CustomTimeRange(time: time).toMap(),
      Keys.ownerId: ownerId,
      Keys.departmentId: departmentId,
      Keys.id: id,
    };
  }
}

class CustomTimeRange {
  final TimeRange time;

  CustomTimeRange({required this.time});

  toMap() {
    return <String, dynamic>{
      Keys.startTimeHour: time.startTime.hour,
      Keys.startTimeMinute: time.startTime.minute,
      Keys.endTimeHour: time.endTime.hour,
      Keys.endTimeMinute: time.endTime.minute,
    };
  }

  CustomTimeRange.fromMap(Map<String, dynamic> map)
      : time = TimeRange(
          startTime: TimeOfDay(
            hour: map[Keys.startTimeHour],
            minute: map[Keys.startTimeMinute],
          ),
          endTime: TimeOfDay(
            hour: map[Keys.endTimeHour],
            minute: map[Keys.endTimeMinute],
          ),
        );
}
