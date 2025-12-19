import 'package:expenseek/controllers/home_controller.dart';
import 'package:expenseek/helpers/format_helper.dart';
import 'package:expenseek/widgets/custom_widget.dart';
import 'package:expenseek/widgets/date_filter_widget.dart';
import 'package:expenseek/widgets/empty_states.dart';
import 'package:expenseek/widgets/loading_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Home Panel
Widget homePanel({required BuildContext context, required HomeController c}) {
  return Column(
    children: [
      Column(
        children: [
          const SizedBox(height: 22),
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Home",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                    ),
                  ),
                ]),
          ),
          const Text(
            "This month spending",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            "₹ ${c.totalAmount.value.nFormat()}",
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          )
        ],
      ),
      const SizedBox(
        height: 16,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          customTile(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Day",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Text(
                    "₹ ${c.dayAmount.value.nFormat()}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            context: context,
          ),
          // Add spacing between tiles
          customTile(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Week",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Text(
                    "₹ ${c.weekAmount.value.nFormat()}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            context: context,
          )
        ],
      ),
      const SizedBox(
        height: 12,
      ),
      dateFilterSelector(c),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: minimalistDropDown(
          selectedValue: c.filterVal.value ?? 0,
          options: c.filterCategories,
          actions: c.filterCatogoryAction,
        ),
      ),
      Expanded(
        child: Obx(() {
          if (c.isLoading.value && c.filteredExpenses.isEmpty) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => expenseCardSkeleton(),
            );
          }
          
          if (c.filteredExpenses.isEmpty) {
            return emptyExpensesState(
              onAddExpense: () => c.doClick(),
            );
          }
          
          return ListView.builder(
          itemCount: c.filteredExpenses.length,
          itemBuilder: (context, index) => customCard(
            child: ListTile(
              trailing: Text(
                "₹ ${c.filteredExpenses.value[index].amount.nFormat()}",
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              title: Text(
                c.filteredExpenses.value[index].title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(c.filteredExpenses.value[index].createdAt.dFormat()),
              onTap: () => c.showExpenseDialog(c.filteredExpenses.value[index].id ?? 0),
            ),
          ),
          );
        }),
      )
    ],
  );
}

// Category Panel
Widget categoryPanel(
    {required BuildContext context, required HomeController c}) {
  return Column(
    children: [
      const SizedBox(height: 16),
      const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            "Categories",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      customTile(
        context: context,
        width: MediaQuery.of(context).size.width - 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              c.categories.length.toString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 12,
      ),
      Expanded(
        child: Obx(() {
          if (c.isLoading.value && c.categories.isEmpty) {
            return ListView.builder(
              itemCount: 5,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => categoryCardSkeleton(),
            );
          }
          
          if (c.categories.isEmpty) {
            return emptyCategoriesState(
              onAddCategory: () => c.doClick(),
            );
          }
          
          return ListView.builder(
          itemCount: c.categories.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) => customCard(
            child: ListTile(
              trailing: const Icon(Icons.delete),
              title: Text(
                c.categories.value[index].categoryName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(c.categories.value[index].createdAt.dFormat()),
              leading: Icon(
                Icons.circle,
                color: Color(int.parse(c.categories[index].color ?? "0")),
              ),
              onTap: () => c.showCategoryDialog(c.categories[index].id ?? 0),
            ),
          ),
          );
        }),
      )
    ],
  );
}

// Stats Panel

Widget statsPanel({required BuildContext context, required HomeController c}) {
  return Column(children: [
    const SizedBox(height: 16),
    const Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Stats",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
            ),
          ]),
    ),
    const Text(
      "This month spending",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    ),
    const SizedBox(
      height: 16,
    ),
    Text(
      "₹ ${c.totalAmount.value.nFormat()}",
      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    ),
    const SizedBox(
      height: 12,
    ),
    Expanded(
      child: ListView.builder(
        itemCount: c.chartData.length,
        itemBuilder: (context, index) => customCard(
          child: ListTile(
            trailing: Text(
              "₹ ${c.chartData.value[index].values.first.nFormat()}",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            title: Text(
              c.chartData.value[index].keys.first,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            //subtitle: Text(c.expenses.value[index].createdAt.dFormat()),
          ),
        ),
      ),
    )
  ]);
}
