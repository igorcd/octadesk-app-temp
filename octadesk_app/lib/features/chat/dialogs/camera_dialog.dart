import 'dart:io';
import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_icon_button.dart';
import 'package:octadesk_app/features/chat/dialogs/components/confirm_button.dart';
import 'package:octadesk_app/features/chat/dialogs/components/record_button.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:camera/camera.dart';

class CameraDialog extends StatefulWidget {
  const CameraDialog({Key? key}) : super(key: key);

  @override
  State<CameraDialog> createState() => _CameraDialogState();
}

class _CameraDialogState extends State<CameraDialog> {
  /// Controller
  CameraController? _cameraController;

  /// Pode tirar foto
  bool _canTakePhoto = false;

  /// Arquivo final
  File? _file;

  void _switchCameras() {}

  /// Tirar foto
  void _takePicture() async {
    setState(() {
      _canTakePhoto = false;
    });
    await _cameraController!.takePicture();
  }

  void _initialize() async {
    var cameras = await availableCameras();
    var controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await controller.initialize();

    setState(() {
      _cameraController = controller;
      _canTakePhoto = true;
    });
  }

  void _confirm() {}

  void _cancel() {}

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    // Renderizar controles da camera
    Widget renderTakePhotoControls() {
      return Stack(
        children: [
          //
          // Botão de tirar a foto
          Center(
            child: RecordButton(
              recording: false,
              active: _canTakePhoto,
              onPressed: _takePicture,
            ),
          ),

          //
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s03),
              child: OctaIconButton(onPressed: _switchCameras, icon: AppIcons.camera),
            ),
          ),

          // Botão de trocar de câmera
        ],
      );
    }

    // Renderizar botões de confirmar
    Widget renderConfirmControls() {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConfirmButton(icon: AppIcons.times, onPressed: _cancel),
            const SizedBox(width: AppSizes.s20),
            ConfirmButton(icon: AppIcons.check, onPressed: _confirm),
          ],
        ),
      );
    }

    return Container(
      color: Colors.black87,
      child: Stack(
        children: [
          //
          // Preview da Camera
          if (_cameraController != null)
            Center(
              child: CameraPreview(
                _cameraController!,
              ),
            ),

          // Preview da foto
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _file != null
                  ? Image.file(
                      File(_file!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // Controllers
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: AppSizes.s30,
              color: Colors.black38,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _file == null ? renderTakePhotoControls() : renderConfirmControls(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
