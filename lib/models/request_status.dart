enum RequestStatus {
  pending,
  accepted,
  rejected;

  @override
  String toString() {
    return this == pending
        ? 'pending'
        : this == accepted
            ? 'accepted'
            : 'rejected';
  }

  static RequestStatus fromString(String string) {
    return string == 'pending'
        ? pending
        : string == 'accepted'
            ? accepted
            : rejected;
  }
}
