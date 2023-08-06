import 'package:flutter/material.dart';
import 'package:kader/constants/keys.dart';
import 'package:kader/models/request_status.dart';

class VacationRequest {
  String? id;
  String departmentId;
  String employeeId;
  String employeeName;
  DateTimeRange dateTimeRange;
  String cause;
  RequestStatus status;

  VacationRequest({
    this.id,
    required this.departmentId,
    required this.employeeId,
    required this.employeeName,
    required this.dateTimeRange,
    required this.cause,
    this.status = RequestStatus.pending,
  });

  factory VacationRequest.fromMap(Map<String, dynamic> map) {
    return VacationRequest(
      id: map[Keys.id],
      employeeId: map[Keys.employeeId],
      departmentId: map[Keys.departmentId],
      employeeName: map[Keys.employeeName],
      dateTimeRange: DateTimeRange(
        start: DateTime.parse(map[Keys.startDate]),
        end: DateTime.parse(map[Keys.endDate]),
      ),
      cause: map[Keys.cause],
      status: RequestStatus.fromString(map[Keys.status]),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.id: id,
      Keys.departmentId: departmentId,
      Keys.employeeId: employeeId,
      Keys.employeeName: employeeName,
      Keys.startDate: dateTimeRange.start.toIso8601String(),
      Keys.endDate: dateTimeRange.end.toIso8601String(),
      Keys.cause: cause,
      Keys.status: status.toString(),
    };
  }
}
