import 'dart:io';
import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_timer.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceRecorderDialog extends StatefulWidget {
  const VoiceRecorderDialog({super.key});

  @override
  State<VoiceRecorderDialog> createState() => _VoiceRecorderDialogState();
}

class _VoiceRecorderDialogState extends State<VoiceRecorderDialog> {
  // Referencia ao recorder
  final _recorder = Record();

  // Controller do timer
  final _timerController = OctaTimerController();

  /// Iniciar a gravação
  void _startRecorder() async {
    var now = DateTime.now();
    var fileName = "${now.microsecondsSinceEpoch}_recorder.opus";

    // Pasta temporário
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Setar diretório do arquivo
    var directory = "$tempPath/$fileName";

    // Start recording
    await _recorder.start(
      path: directory,
      encoder: AudioEncoder.opus,
    );
    _timerController.start();
  }

  /// Parar a gravação
  void _stopRecord() async {
    var filePath = await _recorder.stop();
    _timerController.stop();

    if (filePath is String) {
      Navigator.of(context).pop(filePath);
      return;
    }
  }

  /// Cancelar
  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _startRecorder();
    super.initState();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OctaPulseAnimation(
          child: Image.asset(
            AppIcons.microphoneLg,
            color: Colors.red,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: AppSizes.s04),
        OctaTimer(
          controller: _timerController,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSizes.s16),
        OctaButton(
          text: "Enviar",
          onTap: _stopRecord,
          width: 200,
        ),
        const SizedBox(height: AppSizes.s04),
        OctaTextButton(onPressed: _cancel, text: "Voltar")
      ],
    );
  }
}
