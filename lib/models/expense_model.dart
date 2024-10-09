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
}