import 'package:flutter/material.dart';

/// Empty state widget for when there are no expenses
Widget emptyExpensesState({VoidCallback? onAddExpense}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.receipt_long_outlined,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          'No Expenses Yet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Start tracking your expenses by adding your first expense',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        // if (onAddExpense != null) ...[
        //   const SizedBox(height: 24),
        //   ElevatedButton.icon(
        //     onPressed: onAddExpense,
        //     icon: const Icon(Icons.add),
        //     label: const Text('Add Expense'),
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.purple,
        //       foregroundColor: Colors.white,
        //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        //     ),
        //   ),
        // ],
        const SizedBox(height: 84,)
      ],
    ),
  );
}

/// Empty state widget for when there are no categories
Widget emptyCategoriesState({VoidCallback? onAddCategory}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.category_outlined,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          'No Categories Yet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create categories to organize your expenses',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        if (onAddCategory != null) ...[
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAddCategory,
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ],
    ),
  );
}

/// Empty state widget for filtered expenses
Widget emptyFilteredExpensesState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          'No Expenses Found',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Try adjusting your filters',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

