import 'package:expenseek/interfaces/serializable.dart';
import 'package:expenseek/models/base_model.dart';
import 'package:expenseek/models/category_model.dart';

class ExpenseModel extends BaseModel {
  String _title = "";
  CategoryModel? _category;
  double _amount = 0;
  String _description = "";

  String get title => _title;
  CategoryModel? get category => _category;
  double get amount => _amount;
  String get description => _description;

  ExpenseModel({required String title, required double amount, required String description, CategoryModel? category}) : super(id: 0) {
    _title = title;
    _amount = amount;
    _description = description;
    _category = category;
  }

  ExpenseModel.fromJson(dynamic json) : super.fromJson(json) {
    _title = json["title"];
    _amount = json["amount"];
    _description = json["description"];
    _category = CategoryModel.fromJson({"id" : json["category"], "categoryName": json["categoryName"], "color": json["color"], "createdAt": json["categoryCreated"]});
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