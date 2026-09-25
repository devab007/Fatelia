import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _currentPath;

  // Demande les permissions micro
  Future<bool> requestPermissions() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // Démarrer l'enregistrement
  Future<void> startRecording() async {
    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      throw Exception('Permission micro refusée');
    }

    final Directory tempDir = await getTemporaryDirectory();
    _currentPath = '${tempDir.path}/audio_prompt_${DateTime.now().millisecondsSinceEpoch}.m4a';

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      sampleRate: 16000, // Idéal pour les modèles ASR
      bitRate: 128000,
    );

    await _audioRecorder.start(config, path: _currentPath!);
  }

  // Arrêter l'enregistrement et retourner le chemin du fichier
  Future<String?> stopRecording() async {
    final path = await _audioRecorder.stop();
    return path ?? _currentPath;
  }

  void dispose() {
    _audioRecorder.dispose();
  }
}