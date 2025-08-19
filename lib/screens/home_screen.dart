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
      floatingActionButton: Obx(() => c.screenActive.value != 1 ? FloatingActionButton(
        onPressed: () => c.doClick(),
        child: const Icon(Icons.add),
      ) : const SizedBox.shrink(),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            onTap: (value) {
              c.screenActive.value = value;
              c.pageController.animateToPage(
                value, // Page index
                duration:
                    const Duration(milliseconds: 300), // Duration of animation
                curve: Curves.easeInOut, // Animation curve
              );
            },
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
            ]),
      ),
      body: Center(
        
        child: Obx(() => PageView(
              controller: c.pageController,
              children: [
                homePanel(context: context, c: c),
                statsPanel(context: context, c: c),
                categoryPanel(context: context, c: c)
              ],
              onPageChanged: (i) {
                c.screenActive.value = i;
              },
            )),
      ),
    );
  }
}
