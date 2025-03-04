import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
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
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A random AWESOME idea！てst:'),
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () {
              print('button pressed!');
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
  
}

class RecordingProvider extends ChangeNotifier {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _filePath;
  List<String> _recordings = [];

  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  List<String> get recordings => _recordings;

  RecordingProvider() {
    _init();
  }

  Future<void> _init() async {
    await _recorder.openRecorder();
    await _player.openPlayer();
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> startRecording() async {
    if (!_recorder.isRecording) {
      Directory tempDir = await getApplicationDocumentsDirectory();
      String filePath = '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder.startRecorder(toFile: filePath);
      _filePath = filePath;
      _isRecording = true;
      notifyListeners();
    }
  }

  Future<void> stopRecording() async {
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
      if (_filePath != null) {
        _recordings.add(_filePath!);
      }
      _isRecording = false;
      notifyListeners();
    }
  }

  Future<void> toggleRecording() async {
    if (_isRecording) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  Future<void> playRecording(String path) async {
    if (!_player.isPlaying) {
      await _player.startPlayer(fromURI: path);
      _isPlaying = true;
      notifyListeners();

      _player.onStopped.listen((event) {
        _isPlaying = false;
        notifyListeners();
      });
    }
  }

  Future<void> stopPlaying() async {
    if (_player.isPlaying) {
      await _player.stopPlayer();
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> togglePlaying(String path) async {
    if (_isPlaying) {
      await stopPlaying();
    } else {
      await playRecording(path);
    }
  }

  void deleteRecording(int index) {
    if (index >= 0 && index < _recordings.length) {
      File file = File(_recordings[index]);
      if (file.existsSync()) {
        file.deleteSync();
      }
      _recordings.removeAt(index);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }
}
