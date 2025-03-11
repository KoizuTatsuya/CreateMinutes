import 'package:flutter/material.dart';
import 'navigation_screen.dart';
import '../components/database_service.dart';
import '../components/note.dart';
import 'package:intl/intl.dart';

class RecordingScreen extends StatefulWidget {
  // const HistoryScreen({super.key});

  @override
  RecordingScreenState createState() => RecordingScreenState();
}

class RecordingScreenState extends State<RecordingScreen> {
  late Future<List<Note>> _notesList;

  @override
  void initState() {
    super.initState();
    _notesList = DatabaseService.instance.getNotes();
  }

  String getCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMddHHmmss');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recording Screen'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('This is the recording screen'),
                ElevatedButton(
                  onPressed: () async {
                    await DatabaseService.instance.addNote(
                      Note(
                          title: 'NEW_${getCurrentDateTime()}',
                          content: '詳細情報'),
                    );
                  },
                  child: Icon(Icons.add),
                ),
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
