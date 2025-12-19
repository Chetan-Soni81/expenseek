import 'package:expenseek/exceptions/app_exceptions.dart';
import 'package:expenseek/models/category_model.dart';
import 'package:expenseek/models/expense_model.dart';
import 'package:expenseek/repositories/expense_repository.dart';
import 'package:expenseek/utils/date_filter.dart';
import 'package:expenseek/utils/logger.dart';
import 'package:expenseek/utils/validation.dart';

/// Service layer for expense business logic
class ExpenseService {
  final ExpenseRepository _expenseRepository;

  ExpenseService(this._expenseRepository);

  /// Get all expenses with optional date filter
  Future<List<ExpenseModel>> getAllExpenses({DateFilter? dateFilter}) async {
    try {
      final dateWhereClause = dateFilter?.getDateWhereClause(alias: 'e');
      return await _expenseRepository.getAllExpense(dateWhereClause: dateWhereClause);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get all expenses', e, stackTrace);
      rethrow;
    }
  }

  /// Get expenses by category with optional date filter
  Future<List<Map<String, double>>> getExpensesByCategory(int categoryId, {DateFilter? dateFilter}) async {
    try {
      final dateWhereClause = dateFilter?.getDateWhereClause(alias: 'e');
      return await _expenseRepository.getExpenseByCategory(categoryId, dateWhereClause: dateWhereClause);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get expenses by category', e, stackTrace);
      rethrow;
    }
  }

  /// Add a new expense
  Future<int> addExpense({
    required String title,
    required String amount,
    required String description,
    required int categoryId,
    required List<CategoryModel> categories,
  }) async {
    try {
      final validatedTitle = Validation.validateExpenseTitle(title);
      final validatedAmount = Validation.validateAmount(amount);
      final validatedDescription = Validation.validateDescription(description);

      if (categoryId <= 0) {
        throw ValidationException('Please select a valid category');
      }

      final category = categories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => throw NotFoundException('Category not found'),
      );

      final expense = ExpenseModel(
        title: validatedTitle,
        amount: validatedAmount,
        description: validatedDescription,
        category: category,
      );

      return await _expenseRepository.insertExpense(expense);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to add expense', e, stackTrace);
      rethrow;
    }
  }

  /// Update an existing expense
  Future<int> updateExpense({
    required int expenseId,
    required String title,
    required String amount,
    required String description,
    required int categoryId,
    required List<CategoryModel> categories,
  }) async {
    try {
      if (expenseId <= 0) {
        throw ValidationException('Invalid expense ID');
      }

      final validatedTitle = Validation.validateExpenseTitle(title);
      final validatedAmount = Validation.validateAmount(amount);
      final validatedDescription = Validation.validateDescription(description);

      if (categoryId <= 0) {
        throw ValidationException('Please select a valid category');
      }

      final category = categories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => throw NotFoundException('Category not found'),
      );

      final expense = ExpenseModel(
        id: expenseId,
        title: validatedTitle,
        amount: validatedAmount,
        description: validatedDescription,
        category: category,
      );

      return await _expenseRepository.updateExpense(expense);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update expense', e, stackTrace);
      rethrow;
    }
  }

  /// Delete an expense
  Future<int> deleteExpense(int expenseId) async {
    try {
      if (expenseId <= 0) {
        throw ValidationException('Invalid expense ID');
      }
      return await _expenseRepository.deleteExpense(expenseId);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete expense', e, stackTrace);
      rethrow;
    }
  }

  /// Get total expense with optional date filter
  Future<double> getTotalExpense({DateFilter? dateFilter}) async {
    try {
      final dateWhereClause = dateFilter?.getDateWhereClause();
      return await _expenseRepository.getTotalExpense(dateWhereClause: dateWhereClause);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get total expense', e, stackTrace);
      rethrow;
    }
  }

  /// Get week expense
  Future<double> getWeekExpense() async {
    try {
      return await _expenseRepository.getWeekExpense();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get week expense', e, stackTrace);
      rethrow;
    }
  }

  /// Get day expense
  Future<double> getDayExpense() async {
    try {
      return await _expenseRepository.getDayExpense();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get day expense', e, stackTrace);
      rethrow;
    }
  }
}

