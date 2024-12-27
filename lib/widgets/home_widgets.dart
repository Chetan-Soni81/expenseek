import 'package:expenseek/controllers/home_controller.dart';
import 'package:expenseek/helpers/format_helper.dart';
import 'package:expenseek/widgets/custom_widget.dart';
import 'package:flutter/material.dart';

//Home Panel
Widget homePanel({required BuildContext context, required HomeController c}) {
  return Column(
    children: [
      Column(
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: const EdgeInsets.all(20),
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
            height: 16,
          ),
          Text(
            "₹ ${c.totalAmount.value.nFormat()}",
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          )
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Container(
          //   padding: const EdgeInsets.all(24),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(16),
          //   color: Colors.grey[200],
          //   ),
          //   height: 120,
          //   width:  tileWidth,
          //   child: const Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text("Day", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          //       Text("₹ 1,000.00", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
          //      ],

          //     ),
          // ),
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
      Expanded(
        child: ListView.builder(
          itemCount: c.expenses.length,
          itemBuilder: (context, index) => customCard(
            child: ListTile(
              trailing: Text(
                "₹ ${c.expenses.value[index].amount.nFormat()}",
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              title: Text(
                c.expenses.value[index].title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(c.expenses.value[index].createdAt.dFormat()),
            ),
          ),
        ),
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
        child: ListView.builder(
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
            ),
          ),
        ),
      )
    ],
  );
}
