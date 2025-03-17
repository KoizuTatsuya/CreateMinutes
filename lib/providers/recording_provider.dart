import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

/// 録音状態を定義する列挙型
enum RecordingStatus {
  idle,
  recording,
  paused,
  stopped,
}

class RecordingProvider extends ChangeNotifier {
  final _record = AudioRecorder();

  RecordingStatus _recordingStatus = RecordingStatus.idle;
  RecordingStatus get recordingStatus => _recordingStatus;

  String? _recordedFilePath;
  String? get recordedFilePath => _recordedFilePath;

  String _transcribedText = '';
  String get transcribedText => _transcribedText;
  String _minutesFormattedText = '';
  String get minutesFormattedText => _minutesFormattedText;

  /// 録音を開始
  Future<void> startRecording() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      if (await _record.isRecording()) {
        await _record.stop();
      }

      // 録音ファイルのパスを生成
      final directory = await getExternalStorageDirectory(); // ←外部ストレージに変更
      final filePath = path.join(directory!.path,
          'record_${DateTime.now().millisecondsSinceEpoch}.m4a');

      // 録音を開始
      await _record.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: filePath,
      );

      _recordedFilePath = filePath;
      _recordingStatus = RecordingStatus.recording;
      notifyListeners();
    } else {
      debugPrint('マイクへのアクセスが許可されていません。');
    }
  }

  /// 録音を一時停止
  Future<void> pauseRecording() async {
    if (await _record.isRecording()) {
      await _record.pause();
      _recordingStatus = RecordingStatus.paused;
      notifyListeners();
    }
  }

  /// 一時停止から再開
  Future<void> resumeRecording() async {
    if (await _record.isPaused()) {
      await _record.resume();
      _recordingStatus = RecordingStatus.recording;
      notifyListeners();
    }
  }

  /// 録音を停止してファイルを保存
  Future<void> stopRecording() async {
    if (await _record.isRecording() || await _record.isPaused()) {
      final path = await _record.stop();
      debugPrint('録音ファイルのパス: $path');
      _recordedFilePath = path;
      _recordingStatus = RecordingStatus.stopped;
      notifyListeners();
    }
  }

  /// GeminiFlash APIを利用した文字起こしリクエスト
  Future<void> transcribeAudio() async {
    if (_recordedFilePath == null || _recordedFilePath!.isEmpty) {
      debugPrint('録音ファイルがありません。');
      return;
    }

    //      final meetingScreen = MeetingTranscriptScreen().createState();
    //  meetingScreen.pickAndUploadFile();

    try {
      // ✅ Gemini API キーを設定
      const String apiKey = 'AIzaSyBG6k5F9XIi65zB-e6gNEL4uhu0XIjH93M';
      final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);

      // ✅ 音声ファイルを Base64 に変換
      final File audioFile = File(_recordedFilePath!);
      final Uint8List audioBytes = await audioFile.readAsBytes();

      // ✅ Gemini に送るプロンプト（音声を文字起こし）
      const String transcriptionPrompt = '''
        この音声は、ある会議の音声です。この音声をもとに会議の要約を作成してください。
        音声に含まれていない情報をでっち上げたり、冗長になったりしてはいけません。

        まず、会議の概要、何が議論されたのか、会議の結論、アクションアイテムを冒頭にまとめて記載してください。
        会議の概要には、会議名、日時、参加者が必要です。開催日時などが不明の場合は「不明」と記載してください。
        また内容はMECEである必要があります。

        その後、会議の流れを記載します。
        会議の流れは下記の形式で、それぞれのタイムスタンプごとの話題の概要を記載します。
        もしも補足するべき内容があれば、備考に記載してください。表の中はすべて左詰となるようにします。
        |タイムスタンプ|話題|備考|
      ''';

      print("🔹 ファイルパス: $_recordedFilePath");
      print("🔹 読み込んだバイト数: ${audioBytes.length}");
      print("🔹 最初の 10 バイト: ${audioBytes.sublist(0, 10)}");

      final contents = [
        Content.text(transcriptionPrompt),
        Content.data('audio/wav', audioBytes), // ✅ 音声データを送る
      ];

      // ✅ Gemini に送信（文字起こし）
      GenerateContentResponse response = await model.generateContent(contents);

      print("🔹 結果: ${response.text}");

      if (response.text != null) {
        _transcribedText = response.text!; // 文字起こし結果を保存

        final GenerateContentResponse minutesResponse = response;

        if (minutesResponse.text != null) {
          _minutesFormattedText = response.text!;
          notifyListeners(); // ✅ UI に通知
        } else {
          debugPrint('議事録変換に失敗しました。');
        }
      } else {
        debugPrint('Gemini APIエラー: 文字起こし失敗');
      }
    } catch (e) {
      debugPrint('API呼び出し中にエラーが発生しました: $e');
    }
  }
}
