import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recording_provider.dart';

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recordingProvider = context.watch<RecordingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recording Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRecordingStatus(recordingProvider.recordingStatus),
              const SizedBox(height: 16.0),
              _buildButtons(context, recordingProvider),
              const SizedBox(height: 16.0),
              _buildTranscribeSection(context, recordingProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordingStatus(RecordingStatus status) {
    String message;
    switch (status) {
      case RecordingStatus.idle:
        message = '録音が開始されていません。';
        break;
      case RecordingStatus.recording:
        message = '録音中...';
        break;
      case RecordingStatus.paused:
        message = '一時停止中';
        break;
      case RecordingStatus.stopped:
        message = '録音が停止しました。';
        break;
    }
    return Text(
      message,
      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildButtons(BuildContext context, RecordingProvider provider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: provider.startRecording,
              child: const Text('録音開始'),
            ),
            const SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: provider.stopRecording,
              child: const Text('録音停止'),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: provider.pauseRecording,
              child: const Text('一時停止'),
            ),
            const SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: provider.resumeRecording,
              child: const Text('再開'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTranscribeSection(
      BuildContext context, RecordingProvider provider) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: provider.transcribeAudio,
          child: const Text('文字起こし実行'),
        ),
        const SizedBox(height: 16.0),
        if (provider.transcribedText.isNotEmpty)
          Column(
            children: [
              const Text(
                '【文字起こし結果】',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(provider.transcribedText),
              const SizedBox(height: 8.0),
              // const Text(
              //   '【議事録形式に整形した例】',
              // style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // FutureBuilder<String>(
              //   future: provider.convertToMinutesFormat(provider.transcribedText), // 非同期処理
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator(); // 読み込み中のローディング表示
              //     } else if (snapshot.hasError) {
              //       return Text("エラー: ${snapshot.error}"); // エラー発生時
              //     } else {
              //       return Text(snapshot.data ?? "変換結果なし"); // 変換後の議事録データを表示
              //     }
              //   },
              // ),
            ],
          ),
      ],
    );
  }
}
