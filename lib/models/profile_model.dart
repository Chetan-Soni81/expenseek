class ProfileModel {
  int _id = 0;
  String? _name;
  String? _username;
  String? _password;
  double _totalSpending = 0;

  int get id => _id;
  String? get name => _name;
  String? get username => _username;
  String? get password => _password;
  double get totolSpending => _totalSpending;

  ProfileModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['Name'];
    _username = json['Username'];
    _password = json['Password'];
    _totalSpending = json['totalSpending'];
  }

  Map<String, Object?> toCreate() {
    return {'Name': _name, 'Username': _username, 'Password': _password};
  }

  void addSpending(double amount) {
    _totalSpending += amount;
  }
}
