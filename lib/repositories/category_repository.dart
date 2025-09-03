import 'package:expenseek/helpers/table_helper.dart';
import 'package:expenseek/models/category_model.dart';
import 'package:expenseek/repositories/base_repository.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository extends BaseRepository {
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      var result = await dbHelper.getAllData(TableHelper.tblCategory);

      var categories = result.map((e) => CategoryModel.fromJson(e)).toList();

      return categories;
    } catch (e) {
      print(e);
      return <CategoryModel>[];
    }
  }

  Future<int> insertCategory(String category, String color) async {
    try {
      final json = {
        "categoryName": category,
        "color": color,
        "createdAt": DateTime.now().toString(),
      };
      var result = dbHelper.insertRecord(TableHelper.tblCategory, json, ConflictAlgorithm.replace);

      return result;
    } catch(e) {
      print(e);
      return 0;
    }
  }

  Future<int> updateCategory(CategoryModel category) async {
    try {
     final query = "Update ${TableHelper.tblCategory} set categoryName='${category.categoryName}', color='${category.color}' where id=${category.id}";

     final id = dbHelper.updateRecordQuery(query);

     return id;
    } catch(e) {
      print(e);
      return 0;
    }
  }
}