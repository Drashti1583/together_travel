import '../utils/constants/firebase.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map[CFirebase.name] ?? '',
      email: map[CFirebase.email] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      CFirebase.uid: uid,
      CFirebase.name: name,
      CFirebase.email: email,
    };
  }
}