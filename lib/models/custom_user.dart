import 'package:kader/constants/keys.dart';
import 'package:kader/models/gender.dart';
import 'package:kader/models/user_type.dart';

class CustomUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String idNumber;
  final String photo;
  final Gender gender;
  final UserType type;

  //TODO: remove password from firebase
  CustomUser({
    required this.id,
    required this.type,
    required this.password,
    required this.phoneNumber,
    required this.idNumber,
    required this.photo,
    required this.name,
    required this.email,
    required this.gender,
  });

  //TODO: check
  CustomUser.fromMap(Map<String, dynamic> map)
      : id = map[Keys.id],
        password = map[Keys.password],
        type = UserType.fromString(map[Keys.type]),
        phoneNumber = map[Keys.phoneNumber],
        idNumber = map[Keys.idNumber],
        photo = map[Keys.photo],
        name = map[Keys.name],
        email = map[Keys.email],
        gender = Gender.fromString(map[Keys.gender]);

  //TODO: check
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.id: id,
      Keys.password: password,
      Keys.phoneNumber: phoneNumber,
      Keys.idNumber: idNumber,
      Keys.photo: photo,
      Keys.type: type.toString(),
      Keys.name: name,
      Keys.email: email,
      Keys.gender: gender.toString(),
    };
  }

  //TODO:
  CustomUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? idNumber,
    String? photo,
    Gender? gender,
    UserType? type,
  }) {
    return CustomUser(
      id: id ?? this.id,
      type: type ?? this.type,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      idNumber: idNumber ?? this.idNumber,
      photo: photo ?? this.photo,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
    );
  }
}
