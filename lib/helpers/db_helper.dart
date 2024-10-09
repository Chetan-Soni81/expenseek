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
      id ${DbTypes.idType}
      )

      create table tbl_expense(
        id ${DbTypes.idType},
        title ${DbTypes.textType},
        category ${DbTypes.intType},
        amount ${DbTypes.realType},
        description ${DbTypes.textType},
        createdAt ${DbTypes.timestampType}
      );
""");
  }
}
