import 'User.dart';

class UserReq{
  User user;
  String password;

  UserReq({required this.user,required this.password});

  factory UserReq.fromJson(Map<String, dynamic> json) {
    return UserReq(
      user: User.fromJson(json['utente']),
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'password':password,
  };
}
