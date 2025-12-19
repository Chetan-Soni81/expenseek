import 'package:expenseek/exceptions/app_exceptions.dart';
import 'package:expenseek/helpers/table_helper.dart';
import 'package:expenseek/models/category_model.dart';
import 'package:expenseek/repositories/base_repository.dart';
import 'package:expenseek/utils/logger.dart';
import 'package:sqflite/sqflite.dart' as sql;

class CategoryRepository extends BaseRepository {
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      var result = await dbHelper.getAllData(TableHelper.tblCategory);

      var categories = result.map((e) => CategoryModel.fromJson(e)).toList();

      return categories;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get all categories', e, stackTrace);
      throw DatabaseException('Failed to retrieve categories: ${e.toString()}');
    }
  }

  Future<int> insertCategory(String category, String color) async {
    try {
      final json = {
        "categoryName": category,
        "color": color,
        "createdAt": DateTime.now().toString(),
      };
      var result = await dbHelper.insertRecord(TableHelper.tblCategory, json, sql.ConflictAlgorithm.replace);

      return result;
    } catch(e, stackTrace) {
      AppLogger.error('Failed to insert category', e, stackTrace);
      throw DatabaseException('Failed to insert category: ${e.toString()}');
    }
  }

  Future<int> updateCategory(CategoryModel category) async {
    try {
      // Use parameterized query to prevent SQL injection
      final data = {
        "categoryName": category.categoryName,
        "color": category.color ?? "",
      };
      
      final result = await dbHelper.updateRecord(
        TableHelper.tblCategory,
        data,
        where: 'id = ?',
        whereArgs: [category.id],
      );

      return result;
    } catch(e, stackTrace) {
      AppLogger.error('Failed to update category', e, stackTrace);
      throw DatabaseException('Failed to update category: ${e.toString()}');
    }
  }
}