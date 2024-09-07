import 'dart:math';
import 'package:flutter/material.dart';
import 'package:soilapp/utils/constants.dart';
import 'package:soilapp/utils/index.dart';
import 'package:soilapp/views/home/home.view.dart';

class MainMenuView extends StatelessWidget {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          Color randomColor =
              _getRandomGreenOrBlueColor(); // Generate random background color

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () {
                context.navigator(
                    context, HomeView(category: categories[index]));
              },
              tileColor: randomColor, // Set the random background color
              title: Text(
                categories[index],
                style: TextStyle(
                  color: Colors.grey[200]!, // Keep text color black
                ),
              ),
              minVerticalPadding: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            ),
          );
        },
      ),
    );
  }

  // Method to generate random shades of green and blue
  Color _getRandomGreenOrBlueColor() {
    return Colors.green;
  }
}
