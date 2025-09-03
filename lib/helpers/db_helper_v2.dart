import 'package:expenseek/helpers/db_types.dart';
import 'package:expenseek/helpers/table_helper.dart';
import 'package:expenseek/models/base_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DbHelperV2 {
  late final Future<sql.Database> _database;

  DbHelperV2() {
    _database = _initDb();
  }

  Future<sql.Database> _initDb() async {
    return sql.openDatabase(
      "expenseek_data.db",
      version: 3,
      onCreate: (sql.Database db, int version) async {
        await _createTables(db);
      },
      onUpgrade: (sql.Database db, int oldVersion, int newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(
              "UPDATE ${TableHelper.tblCategory} SET color = '4278190080' WHERE color = 'FFFFFFFF'");
        }
      },
    );
  }

  Future<void> _createTables(sql.Database db) async {
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
        await db.execute(query);
      } catch (e) {
        print("Error creating table: $e");
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    try 
    {
      var db = await _database;
     final List<Map<String, dynamic>> results =
          await db.query(tableName, orderBy: "createdAt");

      return results;
    }
    catch (e) 
    {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllDataQuery(String sqlQuery) async {
    try 
    {
      var db = await _database;
     final List<Map<String, dynamic>> results =
          await db.rawQuery(sqlQuery);

      return results;
    }
    catch (e) 
    {
      print(e);
      return [];
    }
  }

  Future<T> queryValue<T>({required String sqlQuery, List<Object?>? args}) async {
    try {
    var db = await _database;

    var results = await db.rawQuery(sqlQuery, args);

    return results.first.values.first as T;
    }
    catch (e) {
      print(e);
      return null as T;
    }
  }

  Future<int> insertRecord(String tableName, Map<String, dynamic> data, sql.ConflictAlgorithm algorithm) async {
    try 
    {
       var db = await _database;
       var result = await db.insert(tableName, data, conflictAlgorithm: algorithm);
       return result;
    }
    catch (e) 
    {
      print(e);
      return 0;
    }
  }

  Future<int> insertRecordQuery(String sqlQuery) async {
    try
    {
      var db = await _database;
      var result = await db.rawInsert(sqlQuery);
      return result;
    }
    catch (e)
    {
      print(e);
      return 0;
    }
  }

  Future<int> updateRecord(String tableName, Map<String, dynamic> data, sql.ConflictAlgorithm algorithm) async {
    try 
    {
       var db = await _database;
       var result = await db.update(tableName, data, conflictAlgorithm: algorithm);
       return result;
    }
    catch (e) 
    {
      print(e);
      return 0;
    }
  }

  Future<int> updateRecordQuery(String sqlQuery) async {
    try
    {
      var db = await _database;
      var result = await db.rawUpdate(sqlQuery);
      return result;
    }
    catch (e)
    {
      print(e);
      return 0;
    }
  }

}
