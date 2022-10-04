import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';

class MediaAudioContainer extends StatefulWidget {
  final bool isVertical;
  final MessageAttachment attachment;
  const MediaAudioContainer({required this.attachment, required this.isVertical, super.key});

  @override
  State<MediaAudioContainer> createState() => _MediaAudioContainerState();
}

class _MediaAudioContainerState extends State<MediaAudioContainer> {
  // Player
  late AudioPlayer _player;

  // Streams
  final List<StreamSubscription> _streams = [];

  // Duração total
  Duration? _totalDuration;

  /// Posição
  Duration _position = const Duration();

  /// Playing
  bool _playing = false;

  /// Porcentagem
  double _percentage = 0;

  void _initialize() async {
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    if (widget.attachment.url.isNotEmpty) {
      // Adicionar stream de quando mudar a posição
      _streams.add(_player.onPositionChanged.listen((Duration p) {
        setState(() {
          _position = p;
        });

        if (_totalDuration != null) {
          setState(() {
            if (p.inMicroseconds > 0) {
              _percentage = ((p.inMilliseconds / _totalDuration!.inMilliseconds) * 100).ceil().toDouble();
            } else {
              _percentage = 0;
            }
          });
        }
      }));

      // Listener de quando finalizar
      _streams.add(_player.onPlayerComplete.listen((event) {
        setState(() {
          _playing = false;
          _player.seek(Duration.zero);
        });
      }));

      // Listener para quando mudar a duração
      _streams.add(_player.onDurationChanged.listen((event) {
        setState(() {
          _totalDuration = event;
        });
      }));

      // Listener para quando mudar o estado
      _streams.add(_player.onPlayerStateChanged.listen((PlayerState event) {
        setState(() {
          _playing = event == PlayerState.playing;
        });
      }));

      await _player.setSourceUrl(widget.attachment.url);
    }
  }

  /// Quando apertar o play
  void _handlePlayButton() {
    _player.state == PlayerState.playing ? _player.pause() : _player.resume();
  }

  void _onUserChangeValue(double value) async {
    if (_totalDuration != null) {
      var miliseconds = (_totalDuration!.inMilliseconds * value) / 100;
      var duration = Duration(milliseconds: miliseconds.round());
      _player.seek(duration);
      await _player.resume();
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
    for (var stream in _streams) {
      stream.cancel();
    }
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.isVertical ? const EdgeInsets.symmetric(vertical: AppSizes.s06, horizontal: AppSizes.s02) : const EdgeInsets.symmetric(horizontal: AppSizes.s02),
      child: Flex(
        direction: widget.isVertical ? Axis.vertical : Axis.horizontal,
        children: [
          OctaAnimatedIconButton(
            onPressed: _handlePlayButton,
            icon: _playing ? AppIcons.pause : AppIcons.playFill,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02),
              child: Slider(
                onChanged: _totalDuration == null ? null : (value) => setState(() => _percentage = value),
                value: _percentage,
                onChangeStart: (value) => _player.pause(),
                onChangeEnd: (value) => _onUserChangeValue(value),
                min: 0,
                max: 100,
              ),
            ),
          ),
          SizedBox(
            width: AppSizes.s10,
            child: OctaText.bodySmall(
              !_playing && _totalDuration != null ? formatDurationHelper(_totalDuration!) : formatDurationHelper(_position),
            ),
          )
        ],
      ),
    );
  }
}
