import 'package:expenseek/helpers/theme_helper.dart';
import 'package:expenseek/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pallete_widget.dart';
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
            textCapitalization: TextCapitalization.sentences,
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
    {required Function action,
    TextEditingController? controller,
    required RxString colorName}) {
  final colors = PalletHelper.colors;

  controller!.text = "";
  colorName.value = "";
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
          Obx(
            () => palleteWidget(colorName: colorName),
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

Widget customCard({required Widget child}) {
  return Card(
    elevation: 0,
    margin: const EdgeInsets.all(8),
    color: Colors.white,
    child: child,
  );
}

Widget minimalistDropDown(
    {required int selectedValue,
    required List<CategoryModel> options,
    required Function actions}) {
  return DropdownButtonHideUnderline(
    child: DropdownButton<int>(
      value: selectedValue,
      icon: const Icon(Icons.keyboard_arrow_down),
      isExpanded: true,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      dropdownColor: Colors.white,
      items: options.map((CategoryModel item) {
        return DropdownMenuItem<int>(
          value: item.id,
          child: Text(item.categoryName),
        );
      }).toList(),
      onChanged: (value) => actions(value),
    ),
  );
}

Widget customTextField({required TextEditingController textController}) {
  return TextField(
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.deepPurple[600]!,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.deepPurple[600]!,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.deepPurple[700]!,
          width: 2.0,
        ),
      ),
    ),
    controller: textController,
  );
}

Widget customTextArea(
    {required TextEditingController textController,
    required int maxCharactes}) {
  return TextField(
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.deepPurple[600]!,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.deepPurple[600]!,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.deepPurple[700]!,
          width: 2.0,
        ),
      ),
    ),
    controller: textController,
    keyboardType: TextInputType.multiline,
    maxLength: maxCharactes,
  );
}

Widget purpleButton({required String text, required Function action}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      onPressed: () => action(),
      child: Text(text));
}
