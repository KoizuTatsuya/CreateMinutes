import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'screens/history_screen.dart';
import 'providers/recording_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

// import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermissions();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordingProvider()),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> requestPermissions() async {
  // すべてのストレージ権限をリクエスト
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.manageExternalStorage, // Android 10 以上向け
  ].request();

  // 許可されているか確認
  if (statuses[Permission.storage]!.isGranted &&
      statuses[Permission.manageExternalStorage]!.isGranted) {
    print("ストレージアクセス許可済み");
  } else {
    print("ストレージアクセスが拒否されました。設定から手動で許可してください。");
    openAppSettings(); // 設定画面を開く
  }
}

Future<void> deleteDB() async {
  final dbPath = await getDatabasesPath();
  final delpath = path.join(dbPath, 'notes.db');
  await deleteDatabase(delpath);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<String>(
          future: _getFullPath(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('エラー: ${snapshot.error}');
            } else {
              var fullPath = snapshot.data ?? 'パスが見つかりません';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('議事録作成ツール'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()),
                      );
                    },
                    child: Text('データ表示'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await deleteDB();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('データベースがリセットされました')),
                      );
                    },
                    child: Text('DBリセット'),
                  ),
                  //Text(fullPath),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<String> _getFullPath() async {
    final directory = await getApplicationDocumentsDirectory();
    // return path.join(directory.path, 'folder', 'file.txt');
    return path.join(directory.path);
  }
}
