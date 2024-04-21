class ExpenseModel {
  int _id = 0;
  double _amount = 0;
  DateTime? _createdDate;
  DateTime? _updatedDate;
  int? _category;
  int? _user;
  String? _note;

  int get id => _id;
  double get amount => _amount;
  DateTime? get createdDate => _createdDate;
  DateTime? get updatedDate => _updatedDate;
  int? get category => _category;
  int? get user => _user;
  String? get note => _note;

  ExpenseModel.fromJson(dynamic json) {
    _id = json['id'];
    _amount = json['amount'];
    _createdDate = DateTime.tryParse(json['created']);
    _updatedDate = DateTime.tryParse(json['updated']);
    _category = json['category'];
    _user = json['user'];
    _note = json['note'];
  }

  ExpenseModel(
      {required double amount,
      String? note,
      required int category,
      required int user}) {
    _amount = amount;
    _note = note;
    _category = category;
    _user = user;
  }

  Map<String, Object?> toCreate() {
    return {
      'amount': _amount,
      'note': _note,
      'category': _category,
      'user': _user
    };
  }
}
