import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';
import 'dart:math' as math;

// TODO - FAZER REFACTORY DA LÓGICA
class MediaAudioContainer extends StatefulWidget {
  final bool isVertical;
  final MessageAttachment attachment;
  const MediaAudioContainer({required this.attachment, required this.isVertical, Key? key}) : super(key: key);

  @override
  State<MediaAudioContainer> createState() => _MediaAudioContainerState();
}

class _MediaAudioContainerState extends State<MediaAudioContainer> {
  // ==== State ====
  bool playing = false;

  bool loaded = false;

  bool _inError = false;

  Duration totalDuration = const Duration();

  double percentage = 0;

  AudioPlayer audioPlayer = AudioPlayer();

  // ==== Métodos ====
  Future _pause() async {
    await audioPlayer.pause();
    setState(() {
      playing = false;
    });
  }

  Future _resume() async {
    await audioPlayer.resume();
    setState(() {
      playing = true;
    });
  }

  /// Tratar botão de play / payse
  void _handleIteractionButton() async {
    var future = playing ? _pause() : _resume();
    await future;
  }

  void _onUserChangeValue(double value) async {
    var miliseconds = (totalDuration.inMilliseconds * value) / 100;
    var duration = Duration(milliseconds: miliseconds.round());
    audioPlayer.seek(duration);
    await _resume();
  }

  /// Inicializar oi player
  void _initPlayer() async {
    try {
      //
      // Listener de quando mudar de posição
      audioPlayer.onPositionChanged.listen((Duration p) {
        if (totalDuration.inMilliseconds > 0) {
          setState(() {
            percentage = ((p.inMilliseconds / totalDuration.inMilliseconds) * 100).ceil().toDouble();
          });
        }
      });

      // Listener de quando finalizar
      audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          playing = false;
          percentage = 0;
          audioPlayer.seek(Duration.zero);
        });
      });

      audioPlayer.onDurationChanged.listen((event) {
        setState(() => totalDuration = Duration(seconds: event.inSeconds));
      });

      if (mounted) {
        await audioPlayer.setSource(UrlSource(widget.attachment.url));
        setState(() => loaded = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _inError = true);
      }
    }
  }

  @override
  void initState() {
    _initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget renderChild() {
      if (_inError) {
        return const Text("Não foi possível carregar o áudio");
      }

      if (loaded) {
        return OctaAnimatedIconButton(
          onPressed: _handleIteractionButton,
          icon: playing ? AppIcons.pause : AppIcons.play,
        );
      }

      return Container(
        width: AppSizes.s12,
        alignment: Alignment.center,
        child: const SizedBox(
          width: AppSizes.s06,
          height: AppSizes.s06,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Padding(
      padding: widget.isVertical ? EdgeInsets.zero : const EdgeInsets.only(left: AppSizes.s02_5, right: AppSizes.s01),
      child: Flex(
        direction: widget.isVertical ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botão de play / pause / loading
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: renderChild(),
          ),

          // Slider
          Flexible(
            flex: widget.isVertical ? 0 : 1,
            child: Container(
              transform: widget.isVertical ? null : Matrix4.translationValues(-10, 0, 0),
              padding: widget.isVertical ? null : const EdgeInsets.only(right: AppSizes.s02),
              child: totalDuration.inMilliseconds > 0
                  ? Slider(
                      value: math.min(math.max(percentage, 0), 100),
                      min: 0,
                      max: 100,
                      onChangeStart: (value) async => await _pause(),
                      onChanged: (value) => setState(() => percentage = value),
                      onChangeEnd: (value) => _onUserChangeValue(value),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
