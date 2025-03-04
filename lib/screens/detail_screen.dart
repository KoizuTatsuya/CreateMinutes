import 'package:flutter/material.dart';
import 'navigation_screen.dart';

class DataDetailScreen extends StatelessWidget {
  const DataDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Detail Screen'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('This is the data detail screen'),
                SizedBox(height: 100), // スクロール可能なコンテンツの例
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NavigationScreen(),
          ),
        ],
      ),
    );
  }
}
