import 'package:flutter/material.dart';

/// Loading indicator widget
Widget loadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

/// Skeleton loading widget for expense cards
Widget expenseCardSkeleton() {
  return Card(
    elevation: 0,
    margin: const EdgeInsets.all(8),
    color: Colors.white,
    child: ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Container(
        height: 16,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      subtitle: Container(
        margin: const EdgeInsets.only(top: 8),
        height: 12,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      trailing: Container(
        height: 20,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );
}

/// Skeleton loading widget for category cards
Widget categoryCardSkeleton() {
  return Card(
    elevation: 0,
    margin: const EdgeInsets.all(8),
    color: Colors.white,
    child: ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
      title: Container(
        height: 16,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      subtitle: Container(
        margin: const EdgeInsets.only(top: 8),
        height: 12,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );
}

/// Loading overlay widget
Widget loadingOverlay({required bool isLoading, required Widget child}) {
  return Stack(
    children: [
      child,
      if (isLoading)
        Container(
          color: Colors.black.withOpacity(0.3),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
    ],
  );
}

