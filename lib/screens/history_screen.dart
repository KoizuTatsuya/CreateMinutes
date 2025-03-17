import 'package:flutter/material.dart';
import 'navigation_screen.dart';
import '../components/database_service.dart';
import '../components/note.dart';
import 'detail_screen.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  // const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Note>> _notesList;

  @override
  void initState() {
    super.initState();
    _notesList = DatabaseService.instance.getNotes();
  }

  // void _refreshNotes() {
  //   setState(() {
  //     _notesList = DatabaseService.instance.getNotes();
  //   });
  // }

  String getCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMddHHmmss');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('履歴')),
      body: Stack(
        children: [
          FutureBuilder<List<Note>>(
            future: _notesList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final notes = snapshot.data!;
              notes.sort((a, b) =>
                  b.dateUpdate.compareTo(a.dateUpdate)); // dateUpdate の降順にソート
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ListTile(
                    title: Text('${note.title}__${note.id}'),
                    subtitle: Text(note.content),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(note: note),
                        ),
                      );
                    },
                  );
                },
              );
            },
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

// class HistoryScreen2 extends StatelessWidget {
//   const HistoryScreen2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('履歴'),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('This is the data list screen'),
//                 SizedBox(height: 100), // スクロール可能なコンテンツの例
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: NavigationScreen(),
//           ),
//         ],
//       ),
//     );
//   }
// }
