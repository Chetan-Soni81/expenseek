import 'package:expenseek/exceptions/app_exceptions.dart';
import 'package:expenseek/helpers/db_types.dart';
import 'package:expenseek/helpers/table_helper.dart';
import 'package:expenseek/utils/logger.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DbHelperV2 {
  late final Future<sql.Database> _database;

  DbHelperV2() {
    _database = _initDb();
  }

  Future<sql.Database> _initDb() async {
    return sql.openDatabase(
      "expenseek_data.db",
      version: 4,
      onCreate: (sql.Database db, int version) async {
        await _createTables(db);
      },
      onUpgrade: (sql.Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 3) {
          await db.execute(
              "UPDATE ${TableHelper.tblCategory} SET color = '4278190080' WHERE color = 'FFFFFFFF'");
        }
        if (oldVersion < 4) {
          // Create indexes for existing databases
          await _createIndexes(db);
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
      } catch (e, stackTrace) {
        AppLogger.error("Error creating table: $e", e, stackTrace);
        throw DatabaseException("Failed to create database tables: ${e.toString()}");
      }
    }

    // Create indexes for better query performance
    await _createIndexes(db);
  }

  Future<void> _createIndexes(sql.Database db) async {
    List<String> indexQueries = [
      // Index on expense createdAt for faster date filtering
      "CREATE INDEX IF NOT EXISTS idx_expense_createdAt ON ${TableHelper.tblExpense}(createdAt);",
      // Index on expense category for faster category filtering
      "CREATE INDEX IF NOT EXISTS idx_expense_category ON ${TableHelper.tblExpense}(category);",
      // Index on category name for faster lookups
      "CREATE INDEX IF NOT EXISTS idx_category_name ON ${TableHelper.tblCategory}(categoryName);",
    ];

    for (String query in indexQueries) {
      try {
        await db.execute(query);
      } catch (e, stackTrace) {
        AppLogger.warning("Error creating index: $e", e, stackTrace);
        // Don't throw - indexes are optional for functionality
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
    catch (e, stackTrace) 
    {
      AppLogger.error('Failed to get all data from $tableName', e, stackTrace);
      throw DatabaseException('Failed to retrieve data from $tableName: ${e.toString()}');
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
    catch (e, stackTrace) 
    {
      AppLogger.error('Failed to execute query', e, stackTrace);
      throw DatabaseException('Failed to execute query: ${e.toString()}');
    }
  }

  Future<T> queryValue<T>({required String sqlQuery, List<Object?>? args}) async {
    try {
    var db = await _database;

    var results = await db.rawQuery(sqlQuery, args);

    if (results.isEmpty) {
      return null as T;
    }
    return results.first.values.first as T;
    }
    catch (e, stackTrace) {
      AppLogger.error('Failed to query value', e, stackTrace);
      throw DatabaseException('Failed to query value: ${e.toString()}');
    }
  }

  Future<List<Map<String, Object?>>> queryResults({required String sqlQuery, List<Object?>? args}) async {
    try {
    var db = await _database;

    var results = await db.rawQuery(sqlQuery, args);

    return results;
    }
    catch (e, stackTrace) {
      AppLogger.error('Failed to query results', e, stackTrace);
      throw DatabaseException('Failed to query results: ${e.toString()}');
    }
  }

  Future<int> insertRecord(String tableName, Map<String, dynamic> data, sql.ConflictAlgorithm algorithm) async {
    try 
    {
       var db = await _database;
       var result = await db.insert(tableName, data, conflictAlgorithm: algorithm);
       return result;
    }
    catch (e, stackTrace) 
    {
      AppLogger.error('Failed to insert record into $tableName', e, stackTrace);
      throw DatabaseException('Failed to insert record: ${e.toString()}');
    }
  }

  Future<int> insertRecordQuery(String sqlQuery) async {
    try
    {
      var db = await _database;
      var result = await db.rawInsert(sqlQuery);
      return result;
    }
    catch (e, stackTrace)
    {
      AppLogger.error('Failed to insert record via query', e, stackTrace);
      throw DatabaseException('Failed to insert record: ${e.toString()}');
    }
  }

  Future<int> updateRecord(String tableName, Map<String, dynamic> data, {String? where, List<Object?>? whereArgs, sql.ConflictAlgorithm? algorithm}) async {
    try 
    {
       var db = await _database;
       var result = await db.update(
         tableName, 
         data, 
         where: where,
         whereArgs: whereArgs,
         conflictAlgorithm: algorithm ?? sql.ConflictAlgorithm.replace,
       );
       return result;
    }
    catch (e, stackTrace) 
    {
      AppLogger.error('Failed to update record in $tableName', e, stackTrace);
      throw DatabaseException('Failed to update record: ${e.toString()}');
    }
  }

  Future<int> updateRecordQuery(String sqlQuery) async {
    try
    {
      var db = await _database;
      var result = await db.rawUpdate(sqlQuery);
      return result;
    }
    catch (e, stackTrace)
    {
      AppLogger.error('Failed to update record via query', e, stackTrace);
      throw DatabaseException('Failed to update record: ${e.toString()}');
    }
  }

  Future<int> deleteRecord(String tableName, {String? where, List<Object?>? whereArgs}) async {
    try 
    {
       var db = await _database;
       var result = await db.delete(
         tableName, 
         where: where,
         whereArgs: whereArgs,
       );
       return result;
    }
    catch (e, stackTrace) 
    {
      AppLogger.error('Failed to delete record from $tableName', e, stackTrace);
      throw DatabaseException('Failed to delete record: ${e.toString()}');
    }
  }

}
