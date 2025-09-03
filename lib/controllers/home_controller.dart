import 'package:expenseek/models/category_model.dart';
import 'package:expenseek/models/expense_model.dart';
import 'package:expenseek/repositories/category_repository.dart';
import 'package:expenseek/repositories/expense_repository.dart';
import 'package:expenseek/widgets/custom_widget.dart';
import 'package:expenseek/widgets/pallete_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late CategoryRepository categoryRepository;
  late ExpenseRepository expenseRepository;
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

  @override
  void onReady() {
    super.onReady();
    categoryRepository = CategoryRepository();
    expenseRepository = ExpenseRepository();
    loadExpenses();
    loadCategories();
  }

  void loadCategories() async {
    var result = await categoryRepository.getAllCategories();

    categories.value = result;
    filterCategories.value = result.toList();
    filterCategories.add(CategoryModel(id: 0, name: "All"));
    chartData.value = await expenseRepository.getExpenseByCategory(filterVal.value ?? 0);
  }

  void loadExpenses() async {
    var result = await expenseRepository.getAllExpense();

    expenses.value = result;
    filteredExpenses.value = result;

    totalAmount.value = await expenseRepository.getTotalExpense();
    weekAmount.value = await expenseRepository.getWeekExpense();
    dayAmount.value = await expenseRepository.getDayExpense();
    chartData.value = await expenseRepository.getExpenseByCategory(filterVal.value ?? 0);
  }

  void addCategory() async {
    print(colorName.value);
    if (categoryNameController.text.isNotEmpty) {
      var result = await categoryRepository.insertCategory(
          categoryNameController.text.trim(), colorName.value);

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
        categoryVal.value != null &&
        (categoryVal.value ?? 0) > 0) {
      var expense = ExpenseModel(
          title: titleController.text.trim(),
          amount: double.parse(amountController.text),
          description: descriptionController.text,
          category: categories.where((e) => e.id == categoryVal.value).first);
      var result = await expenseRepository.insertExpense(expense);
      loadExpenses();
      Get.back();
      categories.value = categories.where((x) => x.id != 0).toList();
    }
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
    var category = CategoryModel(
        id: id, name: categoryNameController.text, color: colorName.value);

    var i = await categoryRepository.updateCategory(category);

    if (i > 0) Get.back();

    Get.showSnackbar(GetSnackBar(
      title: i == 0 ? "Failed" : " Success",
      message: (i == 0 ? "Category update failed" : "Category Update success"),
      backgroundColor: (i == 0 ? Colors.red : Colors.green),
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(seconds: 1),
    ));
    
    loadCategories();
  }

void showExpenseDialog(int id) {
    ExpenseModel? expense = expenses.where((e) => e.id == id).firstOrNull;

    if (expense == null) return;

    amountController.text = expense.amount.toString();
    descriptionController.text = expense.description;
    categoryVal.value = categories.any((e) => e.id == expense.category!.id) ? expense.category!.id : 0;

  var showCategories = categories.where((e) => e.id != 0).toList();
  
  showCategories.add(CategoryModel(id: 0, name: "Select a Category"));

    Get.dialog(
      Dialog(
        child: Container(
          height: 420,
          width: Get.mediaQuery.size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Expense',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              customTextField(textController: categoryNameController),
              const SizedBox(
                height: 16,
              ),
               DropdownButton(
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
              menuWidth: Get.mediaQuery.size.width - 40,
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

}
