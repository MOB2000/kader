class Meeting {
  String? id;
  final String date;
  final String hour;
  final String duration;
  final String place;
  final String subject;
  final String ownerId;
  final String departmentId;

  Meeting({
    this.id,
    required this.date,
    required this.hour,
    required this.duration,
    required this.place,
    required this.subject,
    required this.ownerId,
    required this.departmentId,
  });

  Meeting.fromMap(Map<String, dynamic> map)
      : date = map['date'],
        subject = map['subject'],
        place = map['place'],
        duration = map['duration'],
        hour = map['hour'],
        departmentId = map['departmentId'],
        ownerId = map['ownerId'],
        id = map['ID'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'subject': subject,
      'place': place,
      'duration': duration,
      'hour': hour,
      'ownerId': ownerId,
      'departmentId': departmentId,
      'ID': id,
    };
  }
}
