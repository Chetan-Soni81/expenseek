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
    return sql.openDatabase("expenseek_data.db", version: 3,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    },
     onUpgrade: (sql.Database database, int oldversion, int version) async{
      try {
        if (oldversion < version) {
          await database.execute("Update ${TableHelper.tblCategory} set color = '4278190080' where color = 'FFFFFFFF'");
        }
      } catch (e) {
        print('Error updating table: $e');
      }
     }
    );
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

  static Future<int> insertCategory(String category, String color) async {
    final db = await DbHelper.db();

    try {
      final json = {
        "categoryName": category,
        "color": color,
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

  static Future<int> updateCategory(CategoryModel category) async {
    final db = await DbHelper.db();

    try {
    //  final json = category.toJson();

    final query = "Update ${TableHelper.tblCategory} set categoryName='${category.categoryName}', color='${category.color}' where id=${category.id}";

     final id = db.rawUpdate(query);

     return id;
    } catch(e) {
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
      var query = "select e.id, e.amount, e.title, e.amount, e.description, e.createdAt, e.category, ifnull(c.categoryName,'') as categoryName, ifnull(c.color,'') as color, ifnull(c.createdAt,date('now')) as categoryCreated from ${TableHelper.tblExpense} as e left join ${TableHelper.tblCategory} as c on e.category=c.id order by e.createdAt desc";

      var result =
          // await db.query(TableHelper.tblExpense, orderBy: "createdAt DESC");
          await db.rawQuery(query);

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

  static Future<List<Map<String, double>>> getExpenseByCategory(int category) async {
    final db = await DbHelper.db();

    try {
      var result = await db.rawQuery(
          "SELECT categoryName, Sum(Amount) amount FROM ${TableHelper.tblExpense} e inner join ${TableHelper.tblCategory} c on e.category=c.Id where strftime('%Y-%m', e.createdAt) = strftime('%Y-%m', 'now') GROUP BY categoryName order by amount desc");

      List<Map<String, double>> data = <Map<String, double>>[];

      for (var item in result) {
        data.add({item["categoryName"].toString(): item["amount"] as double});
      }
      print(result);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
