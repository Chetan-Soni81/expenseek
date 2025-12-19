import 'package:expenseek/di/service_locator.dart';
import 'package:expenseek/exceptions/app_exceptions.dart';
import 'package:expenseek/models/category_model.dart';
import 'package:expenseek/models/expense_model.dart';
import 'package:expenseek/repositories/category_repository.dart';
import 'package:expenseek/repositories/expense_repository.dart';
import 'package:expenseek/services/category_service.dart';
import 'package:expenseek/services/expense_service.dart';
import 'package:expenseek/utils/date_filter.dart';
import 'package:expenseek/utils/logger.dart';
import 'package:expenseek/utils/validation.dart';
import 'package:expenseek/widgets/custom_widget.dart';
import 'package:expenseek/widgets/pallete_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late CategoryRepository categoryRepository;
  late ExpenseRepository expenseRepository;
  late ExpenseService expenseService;
  late CategoryService categoryService;
  RxInt screenActive = 0.obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<CategoryModel> filterCategories = <CategoryModel>[].obs;
  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  RxList<ExpenseModel> filteredExpenses = <ExpenseModel>[].obs;
  RxList<Map<String, double>> chartData = <Map<String, double>>[].obs;
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  Rx<int?> categoryVal = 0.obs;
  Rx<int?> filterVal = 0.obs;
  RxDouble totalAmount = 0.0.obs;
  RxDouble weekAmount = 0.0.obs;
  RxDouble dayAmount = 0.0.obs;
  PageController pageController = PageController();
  RxString colorName = Colors.white.value.toString().obs;
  RxBool isEdit = false.obs;
  RxBool isLoading = false.obs;
  Rx<int> editingExpenseId = 0.obs;
  Rx<DateFilter> currentDateFilter = DateFilter(type: DateFilterType.thisMonth).obs;

  @override
  void onReady() {
    super.onReady();
    categoryRepository = getIt<CategoryRepository>();
    expenseRepository = getIt<ExpenseRepository>();
    expenseService = getIt<ExpenseService>();
    categoryService = getIt<CategoryService>();
    loadExpenses();
    loadCategories();
  }

  void loadCategories() async {
    try {
      isLoading.value = true;
      var result = await categoryService.getAllCategories();

    categories.value = result;
    filterCategories.value = result.toList();
    filterCategories.add(CategoryModel(id: 0, name: "All"));
      chartData.value = await expenseService.getExpensesByCategory(
        filterVal.value ?? 0,
        dateFilter: currentDateFilter.value,
      );
    } catch (e) {
      _showError('Failed to load categories', e);
    } finally {
      isLoading.value = false;
    }
  }

  void loadExpenses() async {
    try {
      isLoading.value = true;
      var result = await expenseService.getAllExpenses(dateFilter: currentDateFilter.value);

    expenses.value = result;
    filteredExpenses.value = result;

      totalAmount.value = await expenseService.getTotalExpense(dateFilter: currentDateFilter.value);
      weekAmount.value = await expenseService.getWeekExpense();
      dayAmount.value = await expenseService.getDayExpense();
      chartData.value = await expenseService.getExpensesByCategory(
        filterVal.value ?? 0,
        dateFilter: currentDateFilter.value,
      );
    } catch (e) {
      _showError('Failed to load expenses', e);
    } finally {
      isLoading.value = false;
    }
  }

  void setDateFilter(DateFilter filter) {
    currentDateFilter.value = filter;
    loadExpenses();
  }

  void _showError(String message, dynamic error) {
    AppLogger.error(message, error);
    Get.showSnackbar(GetSnackBar(
      title: "Error",
      message: error is AppException ? error.message : message,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ));
  }

  void _showSuccess(String message) {
    Get.showSnackbar(GetSnackBar(
      title: "Success",
      message: message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ));
  }

  void addCategory() async {
    try {
      isLoading.value = true;
      var result = await categoryService.addCategory(
        categoryNameController.text,
        colorName.value,
      );

      if (result != 0) {
        categoryNameController.text = "";
        colorName.value = Colors.white.value.toString();
        loadCategories();
        Get.back();
        _showSuccess('Category added successfully');
      } else {
        throw DatabaseException('Failed to add category');
      }
    } catch (e) {
      _showError('Failed to add category', e);
    } finally {
      isLoading.value = false;
    }
  }

  void addExpense() async {
    try {
      isLoading.value = true;
      
      if (editingExpenseId.value != null && editingExpenseId.value! > 0) {
        // Update existing expense
        var result = await expenseService.updateExpense(
          expenseId: editingExpenseId.value!,
          title: titleController.text,
          amount: amountController.text,
          description: descriptionController.text,
          categoryId: categoryVal.value ?? 0,
          categories: categories.where((e) => e.id != 0).toList(),
        );
        if (result > 0) {
          _showSuccess('Expense updated successfully');
        } else {
          throw DatabaseException('Failed to update expense');
        }
      } else {
        // Insert new expense
        var result = await expenseService.addExpense(
          title: titleController.text,
          amount: amountController.text,
          description: descriptionController.text,
          categoryId: categoryVal.value ?? 0,
          categories: categories.where((e) => e.id != 0).toList(),
        );
        if (result != 0) {
          _showSuccess('Expense added successfully');
        } else {
          throw DatabaseException('Failed to add expense');
        }
      }
      
      _clearExpenseForm();
      loadExpenses();
      Get.back();
    } catch (e) {
      _showError('Failed to save expense', e);
    } finally {
      isLoading.value = false;
    }
  }

  void _clearExpenseForm() {
    titleController.text = "";
    amountController.text = "";
    descriptionController.text = "";
    categoryVal.value = 0;
    editingExpenseId.value = 0;
  }

  void doClick() {
    Get.bottomSheet(
      switch (screenActive.value) {
        0 => expenseBottomSheet(
            action: addExpense,
            categories: categories.where((e) => e.id != 0).toList(),
            val: categoryVal,
            title: titleController,
            amount: amountController,
            description: descriptionController),
        1 => Container(),
        2 => categoryBottomSheet(
            action: addCategory,
            controller: categoryNameController,
            colorName: colorName),
        _ => Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Default Sheet',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Get.back(); // Close the bottom sheet
                },
                child: const Text('Close'),
              ),
            ],
          )
      },
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
    );
  }

  void filterCatogoryAction(int filter) {
    filterVal.value = filter;
    if (filterVal.value != null && filterVal.value != 0) {
      filteredExpenses.value =
          expenses.value.where((e) => e.category?.id == filter).toList();
    } else {
      filteredExpenses.value = expenses.value;
    }
  }

  void showCategoryDialog(int id) {
    CategoryModel? category = categories.where((e) => e.id == id).firstOrNull;

    if (category == null) return;

    categoryNameController.text = category.categoryName;
    colorName.value = category.color ?? "";

    Get.dialog(
      Dialog(
        child: Container(
          height: 420,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Edit Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              customTextField(textController: categoryNameController),
              const SizedBox(
                height: 16,
              ),
              Obx(
                () => palleteWidget(colorName: colorName),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300]),
                      onPressed: () => Get.back(),
                      child: const Text("Close")),
                      purpleButton(text: "Save", action: () => updateCategory(id)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateCategory(int id) async {
    try {
      isLoading.value = true;
    var category = CategoryModel(
        id: id, name: categoryNameController.text, color: colorName.value);

      var i = await categoryService.updateCategory(category);

      if (i > 0) {
        Get.back();
        _showSuccess('Category updated successfully');
    loadCategories();
      } else {
        throw DatabaseException('Failed to update category');
      }
    } catch (e) {
      _showError('Failed to update category', e);
    } finally {
      isLoading.value = false;
    }
  }

  void showExpenseDialog(int id) async {
    ExpenseModel? expense = expenses.where((e) => e.id == id).firstOrNull;

    if (expense == null) {
      _showError('Error', NotFoundException('Expense not found'));
      return;
    }

    // Set form values for editing
    titleController.text = expense.title;
    amountController.text = expense.amount.toString();
    descriptionController.text = expense.description;
    categoryVal.value = categories.any((e) => e.id == expense.category?.id) ? expense.category!.id : 0;
    editingExpenseId.value = expense.id ?? 0;

  var showCategories = categories.where((e) => e.id != 0).toList();
  showCategories.add(CategoryModel(id: 0, name: "Select a Category"));

    Get.dialog(
      Dialog(
        child: Container(
          height: 500,
          width: Get.mediaQuery.size.width * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Edit Expense',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => DropdownButton<int>(
              isExpanded: true,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              elevation: 0,
              value: categoryVal.value,
              items: showCategories
                  .map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.categoryName),
                      ))
                  .toList(),
              onChanged: (value) {
                categoryVal.value = value;
              },
              hint: const Text("Select a Category"),
                )),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
            ),
                const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300]),
                      onPressed: () {
                        _clearExpenseForm();
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      onPressed: () => _deleteExpense(id),
                      child: const Text("Delete"),
                    ),
                    purpleButton(text: "Save", action: () {
                      addExpense();
                    }),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteExpense(int id) async {
    try {
      Get.dialog(
        AlertDialog(
          title: const Text('Delete Expense'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Get.back(); // Close confirmation dialog
                try {
                  isLoading.value = true;
                  var result = await expenseService.deleteExpense(id);
                  if (result > 0) {
                    Get.back(); // Close edit dialog
                    _clearExpenseForm();
                    loadExpenses();
                    _showSuccess('Expense deleted successfully');
                  } else {
                    throw DatabaseException('Failed to delete expense');
                  }
                } catch (e) {
                  _showError('Failed to delete expense', e);
                } finally {
                  isLoading.value = false;
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } catch (e) {
      _showError('Failed to delete expense', e);
    }
  }

}
