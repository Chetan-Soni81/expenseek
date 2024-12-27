import 'package:expenseek/controllers/home_controller.dart';
import 'package:expenseek/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Widget customTile(
    {required Widget child, required dynamic context, double? width}) {
  final tileWidth = ((MediaQuery.of(context).size.width - 48) / 2);

  return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.purple.shade50, 
      ),
      height: 120,
      width: width ?? tileWidth,
      child: child);
}

Widget expenseBottomSheet(
    {required Function action,
    required List<CategoryModel> categories,
    required Rx<int?> val,
    TextEditingController? title,
    TextEditingController? amount,
    TextEditingController? description}) {
  title?.text = "";
  amount?.text = "";
  description?.text = "";
  val.value = 0;
  categories.any((e) => e.id == 0)
      ? ""
      : categories.add(CategoryModel(id: 0, name: "Select a Category"));
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Add Expense",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: title,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Amount",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Obx(
            () => DropdownButton(
              isExpanded: true,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              elevation: 0,
              value: val.value,
              items: categories
                  .map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.categoryName),
                      ))
                  .toList(),
              onChanged: (value) {
                val.value = value;
              },
              hint: const Text("Select a Category"),
              menuWidth: Get.mediaQuery.size.width - 40,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: description,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.multiline,
            maxLength: 100,
          ),
          OutlinedButton(
            onPressed: () => action(),
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

Widget categoryBottomSheet(
    {required Function action, TextEditingController? controller}) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Add Category",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Category Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          OutlinedButton(
            onPressed: () => action(),
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

Widget customCard({ required Widget child }) {
  return Card(
    elevation: 0,
    margin: const EdgeInsets.all(8),
    color: Colors.white,
    child: child,
  );
}
