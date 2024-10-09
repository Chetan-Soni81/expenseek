import 'package:expenseek/helpers/db_types.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      create table tbl_category(
        id ${DbTypes.idType},
        categoryName ${DbTypes.textType},
        color ${DbTypes.textType},
        createdAt ${DbTypes.timestampType}
      );

      create table tbl_note(
        id ${DbTypes.idType},
        title ${DbTypes.textType},
        description ${DbTypes.textType},
        createdAt ${DbTypes.timestampType}
      )

      create table tbl_expense(
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
    return sql.openDatabase("expenseek_data.db",version: 1,onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }
}
