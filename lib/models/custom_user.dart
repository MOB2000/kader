import 'package:kader/constants/keys.dart';
import 'package:kader/models/user_type.dart';

class CustomUser {
  String id;
  String name;
  String email;
  String phoneNumber;
  String photoUrl;
  UserType type;

  bool get isAdmin => type == UserType.admin;

  bool get isManager => type == UserType.manager;

  bool get isEmployee => type == UserType.employee;

  CustomUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    required this.type,
  });

  CustomUser.fromMap(Map<String, dynamic> map)
      : id = map[Keys.id],
        name = map[Keys.name],
        email = map[Keys.email],
        phoneNumber = map[Keys.phoneNumber],
        photoUrl = map[Keys.photoUrl],
        type = UserType.fromString(map[Keys.type]);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.id: id,
      Keys.name: name,
      Keys.email: email,
      Keys.phoneNumber: phoneNumber,
      Keys.photoUrl: photoUrl,
      Keys.type: type.toString(),
    };
  }

  CustomUser.empty()
      : this(
          id: '',
          type: UserType.employee,
          phoneNumber: '',
          photoUrl: '',
          name: '',
          email: '',
        );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CustomUser &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
