import 'package:expenseek/helpers/db_types.dart';
import 'package:expenseek/helpers/table_helper.dart';
import 'package:expenseek/models/category_model.dart';
import 'package:expenseek/models/expense_model.dart';
import 'package:expenseek/models/user_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  static Future<void> createTables(sql.Database database) async {
    List<String> createTableQueries = [
      """
  create table ${TableHelper.tblCategory}(
    id ${DbTypes.idType},
    categoryName ${DbTypes.textType},
    color ${DbTypes.textType},
    createdAt ${DbTypes.timestampType}
  );
  """,
      """
  create table ${TableHelper.tblNote}(
    id ${DbTypes.idType},
    title ${DbTypes.textType},
    description ${DbTypes.textType},
    createdAt ${DbTypes.timestampType}
  );
  """,
      """
  create table ${TableHelper.tblExpense}(
    id ${DbTypes.idType},
    title ${DbTypes.textType},
    category ${DbTypes.intType},
    amount ${DbTypes.realType},
    description ${DbTypes.textType},
    createdAt ${DbTypes.timestampType}
  );
  """,
      """
  create table ${TableHelper.tblUser}(
    username TEXT PRIMARY KEY,
    pin ${DbTypes.textType}
  );
  """
    ];

    for (String query in createTableQueries) {
      try {
        await database.execute(query);
      } catch (e) {
        print('Error creating table: $e');
      }
    }
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("expenseek_data.db", version: 2,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<String> userExists() async {
    final db = await DbHelper.db();

    final List<Map<String, dynamic>> results =
        await db.query(TableHelper.tblUser, limit: 1);

    return results.isNotEmpty
        ? results[0]["username"]
        : ""; // Return true if records exist, false otherwise
  }

  static Future<String?> loginUser(UserModel user) async {
    final db = await DbHelper.db();

    final List<Map<String, dynamic>> results = await db.query(
        TableHelper.tblUser,
        where: "username = ? and pin = ?",
        whereArgs: [user.username, user.pin],
        limit: 1);

    if (results.isNotEmpty) {
      final user = UserModel.fromJson(results.first);

      return user.username;
    }

    return "";
  }

   static Future<String?> getUserById(int user) async {
    final db = await DbHelper.db();

    final List<Map<String, dynamic>> results = await db.query(
        TableHelper.tblUser,
        where: "id = ?",
        whereArgs: [user],
        limit: 1);

    if (results.isNotEmpty) {
      final user = UserModel.fromJson(results.first);

      return user.username;
    }

    return "";
  }


  static Future<int> registerUser(UserModel user) async {
    final db = await DbHelper.db();

    try {
      final id = db.insert(TableHelper.tblUser, user.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;
    } catch (e) {
      print("error: " + e.toString());
      return 0;
    }
  }

  static Future<int> insertCategory(String category) async {
    final db = await DbHelper.db();

    try {
      final json = {
        "categoryName": category,
        "color": "FFFFFFFF",
        "createdAt": DateTime.now().toString(),
      };

      final id = db.insert(TableHelper.tblCategory, json,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  static Future<List<CategoryModel>> getAllCategories() async {
    final db = await DbHelper.db();

    try {
      final List<Map<String, dynamic>> results =
          await db.query(TableHelper.tblCategory, orderBy: "createdAt");

      var categories = results.map((e) => CategoryModel.fromJson(e));

      return categories.toList();
    } catch (e) {
      return [];
    }
  }

  static Future<int> insertExpense(ExpenseModel expense) async {
    final db = await DbHelper.db();

    try {
      var result = await db.insert(TableHelper.tblExpense, expense.toInsert(),
          conflictAlgorithm: sql.ConflictAlgorithm.ignore);

      return result;
    } catch (e) {
      print(e);

      return 0;
    }
  }

  static Future<List<ExpenseModel>> getAllExpense() async {
    final db = await DbHelper.db();

    try {
      var result =
          await db.query(TableHelper.tblExpense, orderBy: "createdAt DESC");

      final expenses = result.map((e) => ExpenseModel.fromJson(e)).toList();

      return expenses;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<double> getTotalExpense() async {
    final db = await DbHelper.db();

    try {
      var result = await db
          .rawQuery("select Sum(amount) from ${TableHelper.tblExpense}");
      return result.first.values.first as double;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<double> getWeekExpense() async {
    final db = await DbHelper.db();

    try {
      var result = await db
          .rawQuery("SELECT Sum(Amount) FROM ${TableHelper.tblExpense} where strftime('%Y-%m-%d', createdAt) BETWEEN date('now', 'weekday 0', '-7 days') AND date('now', 'weekday 0');");
      return result.first.values.first as double;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<double> getDayExpense() async {
    final db = await DbHelper.db();

    try {
      var result = await db
          .rawQuery("SELECT Sum(Amount) FROM ${TableHelper.tblExpense} where strftime('%Y-%m-%d', createdAt) = date('now', 'localtime');");
      return result.first.values.first as double;
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
