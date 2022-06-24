import 'package:kader/constants/keys.dart';
import 'package:kader/models/gender.dart';
import 'package:kader/models/user_type.dart';

class CustomUser {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String idNumber;
  final String photoUrl;
  final Gender gender;
  final UserType type;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CustomUser &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  CustomUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.idNumber,
    required this.photoUrl,
    required this.gender,
    required this.type,
  });

  CustomUser.fromMap(Map<String, dynamic> map)
      : id = map[Keys.id],
        name = map[Keys.name],
        email = map[Keys.email],
        phoneNumber = map[Keys.phoneNumber],
        idNumber = map[Keys.idNumber],
        photoUrl = map[Keys.photoUrl],
        gender = Gender.fromString(map[Keys.gender]),
        type = UserType.fromString(map[Keys.type]);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.id: id,
      Keys.name: name,
      Keys.email: email,
      Keys.phoneNumber: phoneNumber,
      Keys.idNumber: idNumber,
      Keys.photoUrl: photoUrl,
      Keys.gender: gender.toString(),
      Keys.type: type.toString(),
    };
  }

  CustomUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? idNumber,
    String? photoUrl,
    Gender? gender,
    UserType? type,
  }) {
    return CustomUser(
      id: id ?? this.id,
      type: type ?? this.type,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      idNumber: idNumber ?? this.idNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
    );
  }
}
