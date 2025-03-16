import 'package:flutter/material.dart';
import 'navigation_screen.dart';
import '../components/database_service.dart';
import '../components/note.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/recording_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';


class RecordingScreen extends StatefulWidget {
  // const HistoryScreen({super.key});

  @override
  RecordingScreenState createState() => RecordingScreenState();
}

class RecordingScreenState extends State<RecordingScreen> {
  late Future<List<Note>> _notesList;
  String _statusText = "録音開始"; // 初期状態のボタンテキスト
  bool _isRecording = false; // 録音中かどうかのフラグ

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
    final recordingProvider = Provider.of<RecordingProvider>(context);

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
                Text(_statusText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), 
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (!_isRecording) {
                      // **録音開始**
                      setState(() {
                        _statusText = "録音中";
                        _isRecording = true;
                      });
                      await recordingProvider.startRecording();
                    } else {
                      // **録音停止 & 文字起こし処理**
                      setState(() {
                        _statusText = "録音完了。議事録作成中．．．";
                      });

                      await recordingProvider.stopRecording(); // 録音停止
                      await _saveTranscribedText(context); // Gemini に連携 & 文字起こし結果を保存

                      setState(() {
                        _statusText = "作成完了! ${_getFileName()}";
                        _isRecording = false;
                      });
                    } 
                  },
                child: Text(_isRecording ? "録音停止" : "録音開始"),
                ),

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

   /// 録音音声を Gemini で文字起こしし、フォルダに保存
  Future<void> _saveTranscribedText(BuildContext context) async {
    // 文字おこし
    final recordingProvider = Provider.of<RecordingProvider>(context, listen: false);

    await recordingProvider.transcribeAudio(); // Gemini で文字起こし
    String savedContentO =recordingProvider.minutesFormattedText;

    if (await Permission.manageExternalStorage.request().isDenied) {
      print("ストレージ権限が拒否されました");
      return;
    }

    // Dowloadフォルダに保存
    final directory = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);;
    final filePath = '$directory/${_getFileName()}';

    try {
      // 上記フルパスにFileクラスのインスタンスを設定
      File savedFileO = File(filePath);

      // ファイルの保存先と内容をログ出力
      print("保存先パス：$filePath");
      print("保存内容：$savedContentO");

      // ファイルパスが正しいかチェック
      if (filePath.isEmpty) {
        throw Exception("ファイルパスが不正です");
      }

      // 上記インスタンスにファイル内容を書き込む（ここで初めてファイルが保存される）
      await savedFileO.writeAsString(savedContentO ?? "");

      print("ファイル保存成功");
    } catch (e) {
      print("ファイル保存中にエラーが発生しました: $e");
    }

    print("保存完了: $filePath");
    
  }

    /// ユーザーがアクセスできるフォルダを作成
  Future<Directory> _createFolder(String saveFolderPath) async {
    // ダウンロードフォルダのパスを取得
    final folderName = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    final newFolder = Directory('$saveFolderPath/$folderName');

    // フォルダが存在しない場合は作成
    if (!(await newFolder.exists())) {
      await newFolder.create(recursive: true);
    }

    return newFolder;  // 保存フォルダを返す
  }

    /// 文字起こしの保存ファイル名
  String _getFileName() {
    return 'AiMinutes_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.txt';
  }
  
}
