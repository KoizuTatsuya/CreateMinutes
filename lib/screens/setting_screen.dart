import 'package:flutter/material.dart';
import 'navigation_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Screen'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('This is the setting screen'),
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
