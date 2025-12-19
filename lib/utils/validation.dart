import 'package:expenseek/exceptions/app_exceptions.dart';

/// Validation utility class for input validation
class Validation {
  /// Validates expense amount
  /// Returns the parsed amount if valid, throws ValidationException otherwise
  static double validateAmount(String amount) {
    if (amount.isEmpty) {
      throw ValidationException('Amount cannot be empty');
    }

    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) {
      throw ValidationException('Invalid amount format');
    }

    if (parsedAmount <= 0) {
      throw ValidationException('Amount must be greater than 0');
    }

    if (parsedAmount > 1000000000) {
      throw ValidationException('Amount is too large');
    }

    return parsedAmount;
  }

  /// Validates category name
  /// Returns trimmed name if valid, throws ValidationException otherwise
  static String validateCategoryName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ValidationException('Category name cannot be empty');
    }

    if (trimmed.length > 50) {
      throw ValidationException('Category name must be 50 characters or less');
    }

    return trimmed;
  }

  /// Validates expense title
  /// Returns trimmed title if valid, throws ValidationException otherwise
  static String validateExpenseTitle(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      throw ValidationException('Title cannot be empty');
    }

    if (trimmed.length > 100) {
      throw ValidationException('Title must be 100 characters or less');
    }

    return trimmed;
  }

  /// Validates expense description
  /// Returns trimmed description if valid, throws ValidationException otherwise
  static String validateDescription(String description) {
    final trimmed = description.trim();
    if (trimmed.length > 500) {
      throw ValidationException('Description must be 500 characters or less');
    }
    return trimmed;
  }

  /// Validates PIN format
  /// Returns true if valid, throws ValidationException otherwise
  static String validatePin(String pin) {
    if (pin.isEmpty) {
      throw ValidationException('PIN cannot be empty');
    }

    if (pin.length < 4 || pin.length > 8) {
      throw ValidationException('PIN must be between 4 and 8 characters');
    }

    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      throw ValidationException('PIN must contain only digits');
    }

    return pin;
  }

  /// Validates username
  /// Returns trimmed username if valid, throws ValidationException otherwise
  static String validateUsername(String username) {
    final trimmed = username.trim();
    if (trimmed.isEmpty) {
      throw ValidationException('Username cannot be empty');
    }

    if (trimmed.length < 3 || trimmed.length > 20) {
      throw ValidationException('Username must be between 3 and 20 characters');
    }

    return trimmed;
  }
}

