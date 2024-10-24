import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Column(
              children: [
                const Text(
                  "This month spending",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "₹ 1,00,000",
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold),
                )
              ],
            ),
              const SizedBox(height: 16,),
              Expanded( child: ListView.builder(itemBuilder: (context, index) => Card(child: ListTile(title: Text("₹ 1,000"),),), itemCount: 10, ))
          ],
        ),
      ),
    );
  }
}
