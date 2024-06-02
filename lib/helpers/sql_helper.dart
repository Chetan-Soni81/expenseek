import 'package:expenseek/models/category_model.dart';
import 'package:expenseek/models/expense_model.dart';
import 'package:expenseek/models/profile_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
CREATE TABLE Profile (
  Username VARCHAR(50) NOT NULL,
  Password VARCHAR(30) NOT NULL,
  totalSpending REAL DEFAULT 0
);

CREATE TABLE Category (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  categoryName VARCHAR(100) NOT NULL
);

CREATE TABLE Expense (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  amount REAL NOT NULL DEFAULT 0,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated TIMESTAMP,
  category INTEGER,
  note VARCHAR(255),
  FOREIGN KEY (category) REFERENCES Category(id) ON DELETE SET NULL
);
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("expenseek_cs.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createProfile(ProfileModel model) async {
    final db = await SQLHelper.db();

    final data = model.toCreate();
    final id = await db.insert('Profile', data,
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);

    return id;
  }

  static Future<int> createCategory(String name) async {
    final db = await SQLHelper.db();

    final data = {'categoryName': name};
    final id = await db.insert('Category', data,
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);

    return id;
  }

  static Future<int> createExpense(ExpenseModel model) async {
    final db = await SQLHelper.db();

    final data = model.toCreate();
    final id = await db.insert('Expense', data,
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);

    return id;
  }

  static Future<ProfileModel?> getProfile() async {
    final db = await SQLHelper.db();
    var data = await db.query('Profile', limit: 1);

    if (data.isEmpty) return null;

    return ProfileModel.fromJson(data[0]);
  }

  static Future<bool> loginProfile(String? username, String? password) async {
    final db = await SQLHelper.db();
    var data = await db.query('Profile',
        where: "username = ? and password = ? ",
        whereArgs: [username, password],
        limit: 1);

    return data.isEmpty ? false : true;
  }

  static Future<List<CategoryModel>> getAllCategories() async {
    final db = await SQLHelper.db();
    var data = await db.query('Category', orderBy: 'categoryName');

    List<CategoryModel> categories =
        List<CategoryModel>.from(data.map((e) => CategoryModel.fromJson(e)));

    return categories;
  }

  static Future<CategoryModel> getCategoryById(int id) async {
    final db = await SQLHelper.db();
    var data =
        await db.query('Category', where: 'id = ?', whereArgs: [id], limit: 1);

    var category = CategoryModel.fromJson(data[0]);

    return category;
  }
}
