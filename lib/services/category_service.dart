import 'package:expenseek/exceptions/app_exceptions.dart';
import 'package:expenseek/models/category_model.dart';
import 'package:expenseek/repositories/category_repository.dart';
import 'package:expenseek/utils/logger.dart';
import 'package:expenseek/utils/validation.dart';

/// Service layer for category business logic
class CategoryService {
  final CategoryRepository _categoryRepository;

  CategoryService(this._categoryRepository);

  /// Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      return await _categoryRepository.getAllCategories();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get all categories', e, stackTrace);
      rethrow;
    }
  }

  /// Add a new category
  Future<int> addCategory(String name, String color) async {
    try {
      final validatedName = Validation.validateCategoryName(name);
      
      if (color.isEmpty) {
        throw ValidationException('Please select a color for the category');
      }

      return await _categoryRepository.insertCategory(validatedName, color);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to add category', e, stackTrace);
      rethrow;
    }
  }

  /// Update an existing category
  Future<int> updateCategory(CategoryModel category) async {
    try {
      if (category.id == null || category.id == 0) {
        throw ValidationException('Invalid category ID');
      }

      final validatedName = Validation.validateCategoryName(category.categoryName);
      
      if (category.color == null || category.color!.isEmpty) {
        throw ValidationException('Please select a color for the category');
      }

      final updatedCategory = CategoryModel(
        id: category.id!,
        name: validatedName,
        color: category.color,
      );

      return await _categoryRepository.updateCategory(updatedCategory);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update category', e, stackTrace);
      rethrow;
    }
  }
}

