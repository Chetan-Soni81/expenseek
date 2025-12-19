import 'package:expenseek/helpers/db_helper_v2.dart';
import 'package:expenseek/repositories/category_repository.dart';
import 'package:expenseek/repositories/expense_repository.dart';
import 'package:expenseek/repositories/user_repository.dart';
import 'package:expenseek/services/category_service.dart';
import 'package:expenseek/services/expense_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> setupServiceLocator() async {
  // Database
  getIt.registerLazySingleton<DbHelperV2>(() => DbHelperV2());

  // Repositories
  getIt.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepository()..dbHelper = getIt<DbHelperV2>(),
  );

  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepository()..dbHelper = getIt<DbHelperV2>(),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository()..dbHelper = getIt<DbHelperV2>(),
  );

  // Services
  getIt.registerLazySingleton<ExpenseService>(
    () => ExpenseService(getIt<ExpenseRepository>()),
  );

  getIt.registerLazySingleton<CategoryService>(
    () => CategoryService(getIt<CategoryRepository>()),
  );
}

