import 'package:flutter/material.dart';
import 'navigation_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data List Screen'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('This is the data list screen'),
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
