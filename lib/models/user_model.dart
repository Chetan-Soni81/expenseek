class UserModel {
  String? _username;
  String? _pin;

  String? get username => _username;
  String? get pin => _pin;


  UserModel.fromJson(dynamic data) {
    _username = data["username"];
    _pin = data["pin"];
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "pin": pin
    };
  }
}