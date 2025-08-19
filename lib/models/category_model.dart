import 'package:expenseek/helpers/format_helper.dart';
import 'package:expenseek/interfaces/serializable.dart';
import 'package:expenseek/models/base_model.dart';

class CategoryModel extends BaseModel implements Serializable {
  String _categoryName = "";
  String? _color;

   String get categoryName => _categoryName;
   String? get color => _color;

  CategoryModel.fromJson(dynamic json) : super.fromJson(json) {
    _categoryName = json["categoryName"];
    _color = json["color"];
  }

  CategoryModel({required int id, required String name, String? color}) : super(id: id){
    _categoryName = name; _color= color;
  }

  @override
   Map<String, dynamic> toJson(){
    return {
      "id":id,
      "categoryName": categoryName,
      "color": color,
      "createdAt": createdAt.sqlFormat(),
    };
   }
}