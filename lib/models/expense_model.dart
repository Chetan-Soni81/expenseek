import 'package:expenseek/models/category_model.dart';

class ExpenseModel {
  int? _id;
  String _title = "";
  CategoryModel? _category;
  double _amount = 0;
  String _description = "";
  DateTime _createdAt = DateTime.now();

  int? get id => _id;
  String get title => _title;
  CategoryModel? get category => _category;
  double get amount => _amount;
  String get description => _description;
  DateTime get createdAt => _createdAt;

  ExpenseModel({required String title, required double amount, required String description, CategoryModel? category}) {
    _title = title;
    _amount = amount;
    _description = description;
    _createdAt = DateTime.now();
    _category = category;
  }

  ExpenseModel.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    _amount = json["amount"];
    _description = json["description"];
    _createdAt = DateTime.parse(json["createdAt"]);
  }

  Map<String, dynamic> toInsert() {
    return {
      "title": title,
      "amount": amount,
      "description": description,
      "createdAt": createdAt.toString(),
      "category": category?.id 
    };
  }
}