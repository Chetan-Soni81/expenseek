import 'package:expenseek/models/category_model.dart';

class ExpenseModel {
  int? _id;
  String _title = "";
  CategoryModel? _category;
  double _amount = 0;
  DateTime _createdDate = DateTime.now();
  String _description = "";

  int? get id => _id;
  String get title => _title;
  CategoryModel? get category => _category;
  double get amount => _amount;
  DateTime get createdDate => _createdDate;
  String get description => _description;
}