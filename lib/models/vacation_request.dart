import 'package:flutter/material.dart';
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
      id: map['id'],
      employeeId: map['employeeId'],
      departmentId: map['departmentId'],
      employeeName: map['employeeName'],
      dateTimeRange: DateTimeRange(
        start: DateTime.parse(map['startDate']),
        end: DateTime.parse(map['endDate']),
      ),
      cause: map['cause'],
      status: RequestStatus.fromString(map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'departmentId': departmentId,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'startDate': dateTimeRange.start.toIso8601String(),
      'endDate': dateTimeRange.end.toIso8601String(),
      'cause': cause,
      'status': status.toString(),
    };
  }
}
