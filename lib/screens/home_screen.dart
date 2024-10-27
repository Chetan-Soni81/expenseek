import 'package:expenseek/widgets/custom_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tileWidth = ((MediaQuery.of(context).size.width - 48) / 2);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "This month spending",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "₹ 1,00,000",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Day",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "₹ 1,000.00",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  context: context,
                ),
                // Add spacing between tiles
                customTile(
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Week",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "₹ 7,000.00",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  context: context,
                )
              ],
            ),
            ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => new ListTile(),
            ),
          ],
        ),
      ),
    );
  }
}
