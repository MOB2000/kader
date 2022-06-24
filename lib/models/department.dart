import 'package:kader/constants/keys.dart';

class Department {
  String? id;
  String name;
  String managerId;

  Department({
    this.id,
    required this.name,
    required this.managerId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.id: id,
      Keys.name: name,
      'manager_id': managerId,
    };
  }

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'],
      name: map['name'],
      managerId: map['manager_id'],
    );
  }
}
