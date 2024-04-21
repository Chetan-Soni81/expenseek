import 'package:expenseek/models/category_model.dart';
import 'package:expenseek/models/expense_model.dart';
import 'package:expenseek/models/profile_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
Create Table Profile (
  id Integer Primary Key Autoincrement not null,
  Username varchar(50) not null,
  Password varchar(30) not null,
  Name varchar(100) not null
  totalSpending REAL default 0
)

Create Table Category (
  id Integer Primary key Autoincrement not null,
  categoryName varchar(100) not null
)

Create Table Expense(
      id Integer Primary key Autoincrement not null,
      amount real not null default 0,
      created timestamp not null default CURRENT_TIMESTAMP,
      updated timestamp,
      category int,
      note varchar(255)
      )
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

  static Future<ProfileModel> getProfileByUsername(String username) async {
    final db = await SQLHelper.db();
    var data = await db.query('Profile',
        where: "username = ? ", whereArgs: [username], limit: 1);

    return ProfileModel.fromJson(data[0]);
  }

  static Future<ProfileModel> getProfileById(int id) async {
    final db = await SQLHelper.db();
    var data =
        await db.query('Profile', where: "id = ? ", whereArgs: [id], limit: 1);

    return ProfileModel.fromJson(data[0]);
  }

  static Future<int> loginProfile(String? username, String? password) async {
    final db = await SQLHelper.db();
    var data = await db.query('Profile',
        where: "username = ? and password = ? ",
        whereArgs: [username, password],
        limit: 1);

    return data.isEmpty ? 0 : int.parse(data[0]['id'].toString());
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
