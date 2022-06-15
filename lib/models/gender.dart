enum Gender {
  male,
  female;

  @override
  String toString() {
    return this == male ? 'male' : 'female';
  }

  static Gender fromString(String string) {
    return string == 'male' ? male : female;
  }
}
