import 'package:kader/constants/keys.dart';

enum UserType {
  admin,
  manager,
  employee;

  @override
  String toString() {
    return this == admin
        ? Keys.admin
        : this == manager
            ? Keys.manager
            : Keys.employee;
  }

  static UserType fromString(String string) {
    return string == Keys.admin
        ? admin
        : string == Keys.manager
            ? manager
            : employee;
  }
}
