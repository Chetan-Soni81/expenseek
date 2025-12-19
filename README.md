# Expenseek

A modern, feature-rich expense tracking application built with Flutter. Track your daily expenses, manage categories, view statistics, and export your data.

## Features

### Core Functionality
- **Expense Management**: Add, edit, and delete expenses with detailed information
- **Category Management**: Create and manage custom expense categories with color coding
- **Date Filtering**: Filter expenses by Today, This Week, This Month, This Year, or custom date ranges
- **Statistics Dashboard**: View spending statistics including daily, weekly, and monthly totals
- **Data Export**: Export expenses to CSV format for external analysis

### User Experience
- **Modern UI**: Clean and intuitive Material Design interface
- **Loading States**: Skeleton screens and loading indicators for better UX
- **Empty States**: Helpful empty state messages with call-to-action buttons
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Input Validation**: Robust validation for all user inputs

### Technical Features
- **Local Storage**: SQLite database for offline-first functionality
- **State Management**: GetX for reactive state management
- **Dependency Injection**: Clean architecture with service locator pattern
- **Service Layer**: Separation of concerns with dedicated service classes
- **Logging**: Comprehensive logging system for debugging
- **Security**: Parameterized queries to prevent SQL injection

## Getting Started

### Prerequisites

- Flutter SDK (3.5.1 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDEs)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd expenseek
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Production

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Windows/Linux/MacOS
```bash
flutter build windows --release
flutter build linux --release
flutter build macos --release
```

## Project Structure

```
lib/
├── controllers/       # GetX controllers for state management
├── di/                # Dependency injection setup
├── exceptions/        # Custom exception classes
├── helpers/           # Helper utilities (database, formatting, etc.)
├── models/            # Data models
├── repositories/      # Data access layer
├── screens/           # UI screens
├── services/          # Business logic layer
├── utils/             # Utility classes (validation, logging, etc.)
└── widgets/           # Reusable UI components
```

## Architecture

The project follows a clean architecture pattern:

- **Controllers**: Handle UI state and user interactions
- **Services**: Contain business logic and orchestrate repository calls
- **Repositories**: Abstract data access and handle database operations
- **Models**: Represent data structures
- **Widgets**: Reusable UI components

## Key Dependencies

- `get`: State management and routing
- `sqflite`: Local SQLite database
- `get_it`: Dependency injection
- `logger`: Logging framework
- `intl`: Internationalization and date formatting
- `csv`: CSV export functionality
- `share_plus`: File sharing

## Database Schema

The app uses SQLite with the following tables:
- `expenses`: Stores expense records
- `categories`: Stores expense categories
- `users`: Stores user authentication data
- `notes`: Stores notes (for future use)

Indexes are created on frequently queried columns for optimal performance.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

## Support

For issues and questions, please open an issue on the GitHub repository.
