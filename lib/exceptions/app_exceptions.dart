/// Base exception class for application-specific exceptions
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

/// Exception thrown when database operations fail
class DatabaseException extends AppException {
  DatabaseException(String message, [String? code]) : super(message, code);
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  ValidationException(String message, [String? code]) : super(message, code);
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  NotFoundException(String message, [String? code]) : super(message, code);
}

