import 'package:flutter/material.dart';
import 'navigation_screen.dart';
import '../components/note.dart';
import '../components/database_service.dart';

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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('登録日時: ${note.dateCreate}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('更新日時: ${note.dateUpdate}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('メモ:', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 5),
                  Text(note.content, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await DatabaseService.instance.deleteNote(note.id!);
                      Navigator.pop(context);
                    },
                    child: Text('削除'),
                  ),
                ],
              ),
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
