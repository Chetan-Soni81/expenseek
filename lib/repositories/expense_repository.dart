import 'package:expenseek/helpers/table_helper.dart';
import 'package:expenseek/models/expense_model.dart';
import 'package:expenseek/repositories/base_repository.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository extends BaseRepository
{
  Future<List<ExpenseModel>> getAllExpense() async {
    try {
      final query = "select e.id, e.amount, e.title, e.amount, e.description, e.createdAt, e.category, ifnull(c.categoryName,'') as categoryName, ifnull(c.color,'') as color, ifnull(c.createdAt,date('now')) as categoryCreated from ${TableHelper.tblExpense} as e left join ${TableHelper.tblCategory} as c on e.category=c.id order by e.createdAt desc";

      var result = await dbHelper.queryResults(sqlQuery: query);

      final expenses = result.map((e) => ExpenseModel.fromJson(e)).toList();

      return expenses;
    } catch (e) {
      print(e);
      return <ExpenseModel>[];
    }
  } 

  Future<List<Map<String, double>>> getExpenseByCategory(int category) async {
    List<Map<String, double>> data = <Map<String, double>>[];
    try {
      var result = await dbHelper.queryResults(sqlQuery: 
          "SELECT categoryName, Sum(Amount) amount FROM ${TableHelper.tblExpense} e inner join ${TableHelper.tblCategory} c on e.category=c.Id where strftime('%Y-%m', e.createdAt) = strftime('%Y-%m', 'now') GROUP BY categoryName order by amount desc");

      for (var item in result) {
        data.add({item["categoryName"].toString(): item["amount"] as double});
      }
    } catch(e) {
      print(e);
    } 
    return data;
  }

  Future<int> insertExpense(ExpenseModel expense) async {
    try {
      var result = dbHelper.insertRecord(TableHelper.tblExpense, expense.toInsert(), ConflictAlgorithm.ignore);

      return result;
    } catch(e) {
      print(e);
      return 0;
    }
  }

  Future<double> getTotalExpense() async {
    try {
      var result = dbHelper.queryValue<double>(sqlQuery: "select CAST(IFNULL(Sum(amount),0) AS REAL) from ${TableHelper.tblExpense}");

      return result;
    }
    catch (e) 
    {
      print(e);
      return 0;
    }
  }

  Future<double> getWeekExpense() async {
    try {
      var result = dbHelper.queryValue<double>(sqlQuery: "SELECT CAST(IFNULL(Sum(amount),0) AS REAL) FROM ${TableHelper.tblExpense} where strftime('%Y-%m-%d', createdAt) BETWEEN date('now', 'weekday 0', '-7 days') AND date('now', 'weekday 0');");

      return result;
    }
    catch(e)
    {
      print(e);
      return 0;
    }
  }

  Future<double> getDayExpense() async {
    try {
      var result = dbHelper.queryValue<double>(sqlQuery: "SELECT CAST(IFNULL(Sum(amount),0) AS REAL) FROM ${TableHelper.tblExpense} where strftime('%Y-%m-%d', createdAt) = date('now', 'localtime');");

      return result;
    }
    catch(e)
    {
      print(e);
      return 0;
    }
  }
}