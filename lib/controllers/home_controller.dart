import 'package:expenseek/helpers/db_helper.dart';
import 'package:expenseek/models/category_model.dart';
import 'package:expenseek/models/expense_model.dart';
import 'package:expenseek/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt screenActive = 0.obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  RxList<Map<String, double>> chartData = <Map<String, double>>[].obs;
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  Rx<int?> categoryVal = 0.obs;
  RxDouble totalAmount = 0.0.obs;
  RxDouble weekAmount = 0.0.obs;
  RxDouble dayAmount = 0.0.obs;
  PageController pageController = PageController();

  @override
  void onReady() {
    super.onReady();
    loadExpenses();
    loadCategories();
  }

  void loadCategories() async {
    var result = await DbHelper.getAllCategories();

    categories.value = result;
    
    chartData.value = await DbHelper.getExpenseByCategory();
  }

  void loadExpenses() async {
    var result = await DbHelper.getAllExpense();

    expenses.value = result;

    totalAmount.value = await DbHelper.getTotalExpense();
    weekAmount.value = await DbHelper.getWeekExpense();
    dayAmount.value = await DbHelper.getDayExpense();
    chartData.value = await DbHelper.getExpenseByCategory();
  }

  void addCategory() async {
    if (categoryNameController.text.isNotEmpty) {
      var result = await DbHelper.insertCategory(categoryNameController.text.trim());

      if (result != 0) {
        categoryNameController.text = "";
        loadCategories();
        Get.back();
      }
    }
  }

  void addExpense() async {
    if (titleController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        double.parse(amountController.text) > 0 &&
        categoryVal.value != null && (categoryVal.value ?? 0) > 0) {
      var expense = ExpenseModel(
        title: titleController.text.trim(),
        amount: double.parse(amountController.text),
        description: descriptionController.text,
        category: categories.where((e) => e.id == categoryVal.value).first
      );
      var result = await DbHelper.insertExpense(expense);
      loadExpenses();
      Get.back();
      categories.value = categories.where((x) => x.id != 0).toList();
      
    }
  }

  void doClick() {
    Get.bottomSheet(
      switch (screenActive.value) {
        0 => expenseBottomSheet(
            action: addExpense, categories: categories, val: categoryVal, title: titleController, amount: amountController, description: descriptionController),
        1 => Container(),
        2 => categoryBottomSheet(
            action: addCategory, controller: categoryNameController),
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
}
