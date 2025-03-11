import 'package:flutter/material.dart';
import 'navigation_screen.dart';
import '../components/note.dart';

class DetailScreen extends StatelessWidget {
  // const DetailScreen({super.key});
  final Note note;

  DetailScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      // body: Stack(
      //   // padding: EdgeInsets.all(16.0),
      //   // child: Text(note.content, style: TextStyle(fontSize: 18)),

      // ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(note.content, style: TextStyle(fontSize: 18)),
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
