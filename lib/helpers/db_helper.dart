import 'package:expenseek/helpers/db_types.dart';
import 'package:expenseek/helpers/table_helper.dart';
import 'package:expenseek/models/user_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      create table tblCategory(
        id ${DbTypes.idType},
        categoryName ${DbTypes.textType},
        color ${DbTypes.textType},
        createdAt ${DbTypes.timestampType}
      );

      create table tblNote(
        id ${DbTypes.idType},
        title ${DbTypes.textType},
        description ${DbTypes.textType},
        createdAt ${DbTypes.timestampType}
      )

      create table tblExpense(
        id ${DbTypes.idType},
        title ${DbTypes.textType},
        category ${DbTypes.intType},
        amount ${DbTypes.realType},
        description ${DbTypes.textType},
        createdAt ${DbTypes.timestampType}
      );

      create table tbl_user(
        username TEXT PRIMARY KEY,
        pin ${DbTypes.textType}
      );
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("expenseek_data.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<bool> userExists() async {
    final db = await DbHelper.db();

    final List<Map<String, dynamic>> results =
        await db.query(TableHelper.tblUser, limit: 1);

    return results.isNotEmpty; // Return true if records exist, false otherwise
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

  static Future<int> registerUser(UserModel user) async {
    final db = await DbHelper.db(); 

    final id = db.insert(TableHelper.tblUser, user.toJson(), conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }
}
