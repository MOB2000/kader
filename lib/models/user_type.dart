enum UserType {
  admin,
  manager,
  employee;

  @override
  String toString() {
    return this == admin
        ? 'admin'
        : this == manager
            ? 'manager'
            : 'employee';
  }

  static UserType fromString(String string) {
    return string == 'admin'
        ? admin
        : string == 'manager'
            ? manager
            : employee;
  }
}
