import 'package:expenseek/exceptions/app_exceptions.dart';
import 'package:expenseek/helpers/table_helper.dart';
import 'package:expenseek/models/expense_model.dart';
import 'package:expenseek/repositories/base_repository.dart';
import 'package:expenseek/utils/logger.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ExpenseRepository extends BaseRepository
{
  Future<List<ExpenseModel>> getAllExpense({String? dateWhereClause}) async {
    try {
      // Fixed duplicate column 'e.amount' in SELECT clause
      final dateFilter = dateWhereClause ?? "strftime('%Y-%m', e.createdAt) = strftime('%Y-%m', 'now')";
      final query = "select e.id, e.amount, e.title, e.description, e.createdAt, e.category, ifnull(c.categoryName,'') as categoryName, ifnull(c.color,'') as color, ifnull(c.createdAt,date('now')) as categoryCreated from ${TableHelper.tblExpense} as e left join ${TableHelper.tblCategory} as c on e.category=c.id where $dateFilter order by e.createdAt desc";

      var result = await dbHelper.queryResults(sqlQuery: query);

      final expenses = result.map((e) => ExpenseModel.fromJson(e)).toList();

      return expenses;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get all expenses', e, stackTrace);
      throw DatabaseException('Failed to retrieve expenses: ${e.toString()}');
    }
  } 

  Future<List<Map<String, double>>> getExpenseByCategory(int category, {String? dateWhereClause}) async {
    List<Map<String, double>> data = <Map<String, double>>[];
    try {
      final dateFilter = dateWhereClause ?? "strftime('%Y-%m', e.createdAt) = strftime('%Y-%m', 'now')";
      var result = await dbHelper.queryResults(sqlQuery: 
          "SELECT categoryName, Sum(Amount) amount FROM ${TableHelper.tblExpense} e inner join ${TableHelper.tblCategory} c on e.category=c.Id where $dateFilter GROUP BY categoryName order by amount desc");

      for (var item in result) {
        data.add({item["categoryName"].toString(): item["amount"] as double});
      }
    } catch(e, stackTrace) {
      AppLogger.error('Failed to get expenses by category', e, stackTrace);
      throw DatabaseException('Failed to retrieve expenses by category: ${e.toString()}');
    } 
    return data;
  }

  Future<int> insertExpense(ExpenseModel expense) async {
    try {
      var result = await dbHelper.insertRecord(TableHelper.tblExpense, expense.toInsert(), sql.ConflictAlgorithm.ignore);

      return result;
    } catch(e, stackTrace) {
      AppLogger.error('Failed to insert expense', e, stackTrace);
      throw DatabaseException('Failed to insert expense: ${e.toString()}');
    }
  }

  Future<int> updateExpense(ExpenseModel expense) async {
    try {
      if (expense.id == null || expense.id == 0) {
        throw ValidationException('Expense ID is required for update');
      }

      final data = expense.toInsert();
      final result = await dbHelper.updateRecord(
        TableHelper.tblExpense,
        data,
        where: 'id = ?',
        whereArgs: [expense.id],
      );

      return result;
    } catch(e, stackTrace) {
      AppLogger.error('Failed to update expense', e, stackTrace);
      if (e is ValidationException) {
        rethrow;
      }
      throw DatabaseException('Failed to update expense: ${e.toString()}');
    }
  }

  Future<int> deleteExpense(int expenseId) async {
    try {
      if (expenseId <= 0) {
        throw ValidationException('Invalid expense ID');
      }

      // Delete expense record
      final result = await dbHelper.deleteRecord(
        TableHelper.tblExpense,
        where: 'id = ?',
        whereArgs: [expenseId],
      );

      return result;
    } catch(e, stackTrace) {
      AppLogger.error('Failed to delete expense', e, stackTrace);
      if (e is ValidationException) {
        rethrow;
      }
      throw DatabaseException('Failed to delete expense: ${e.toString()}');
    }
  }

  Future<double> getTotalExpense({String? dateWhereClause}) async {
    try {
      final dateFilter = dateWhereClause ?? "strftime('%Y-%m', createdAt) = strftime('%Y-%m', 'now')";
      var result = await dbHelper.queryValue<double>(sqlQuery: "select CAST(IFNULL(Sum(amount),0) AS REAL) from ${TableHelper.tblExpense} where $dateFilter");

      return result;
    }
    catch (e, stackTrace) 
    {
      AppLogger.error('Failed to get total expense', e, stackTrace);
      throw DatabaseException('Failed to retrieve total expense: ${e.toString()}');
    }
  }

  Future<double> getWeekExpense() async {
    try {
      var result = await dbHelper.queryValue<double>(sqlQuery: "SELECT CAST(IFNULL(Sum(amount),0) AS REAL) FROM ${TableHelper.tblExpense} where strftime('%Y-%m-%d', createdAt) BETWEEN date('now', 'weekday 0', '-7 days') AND date('now', 'weekday 0');");

      return result;
    }
    catch(e, stackTrace)
    {
      AppLogger.error('Failed to get week expense', e, stackTrace);
      throw DatabaseException('Failed to retrieve week expense: ${e.toString()}');
    }
  }

  Future<double> getDayExpense() async {
    try {
      var result = await dbHelper.queryValue<double>(sqlQuery: "SELECT CAST(IFNULL(Sum(amount),0) AS REAL) FROM ${TableHelper.tblExpense} where strftime('%Y-%m-%d', createdAt) = date('now', 'localtime');");

      return result;
    }
    catch(e, stackTrace)
    {
      AppLogger.error('Failed to get day expense', e, stackTrace);
      throw DatabaseException('Failed to retrieve day expense: ${e.toString()}');
    }
  }
}