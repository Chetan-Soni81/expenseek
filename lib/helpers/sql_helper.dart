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

  static Future<int> createProfile(String title, String? desc) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'desc': desc};
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

}
