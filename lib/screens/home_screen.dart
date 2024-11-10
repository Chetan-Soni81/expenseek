import 'package:expenseek/controllers/home_controller.dart';
import 'package:expenseek/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController c = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => switch(c.screenActive.value) { 0 =>  const Text("Home"), 2 => const Text("Categories"), _ => const Text("Home")},),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
      //   ],
      //   elevation: 0,
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => c.doClick(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Obx ( () =>BottomNavigationBar(
        onTap: (value) => c.screenActive.value = value,
        currentIndex: c.screenActive.value,
        items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stacked_bar_chart),
          label: "Stats",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: "Categories",
        ),
      ]),),
      body: Center(
      child: Obx(() => switch (c.screenActive.value) {
        0 => homePanel(context: context, c: c),
        2 => categoryPanel(context: context, c: c),
        _ => homePanel(context: context, c: c)
      }),
      ),
    );
  }
}
