import 'package:expenseek/interfaces/serializable.dart';

class UserModel implements Serializable {
  String? _username;
  String? _pin;

  String? get username => _username;
  String? get pin => _pin;

  UserModel({String? username, String? pin}) {
    _username = username;
    _pin = pin;
  }

  UserModel.fromJson(dynamic data) {
    _username = data["username"];
    _pin = data["pin"];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "pin": pin
    };
  }
}