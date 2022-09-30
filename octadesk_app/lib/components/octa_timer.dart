import 'dart:async';
import 'package:flutter/material.dart';

class OctaTimerController extends ChangeNotifier {
  bool _started = false;
  bool get started => _started;
  Timer? _timer;
  int _ellapsedSeconds = 0;
  int get ellapsedSeconds => _ellapsedSeconds;

  DateTime? _startTime;

  void start() {
    _startTime = DateTime.now();
    _started = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _ellapsedSeconds += 1;
      if (_timer?.isActive == true) {
        notifyListeners();
      }
    });
  }

  Duration stop() {
    if (!_started) {
      throw "O relógio não está iniciado";
    }
    _timer?.cancel();
    Duration duration = DateTime.now().difference(_startTime!);

    _started = false;
    notifyListeners();
    return duration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class OctaTimer extends StatefulWidget {
  final OctaTimerController controller;
  final TextStyle? style;
  const OctaTimer({this.style, required this.controller, Key? key}) : super(key: key);

  @override
  State<OctaTimer> createState() => _OctaTimerState();
}

class _OctaTimerState extends State<OctaTimer> {
  int _ellapsedSeconds = 0;

  void _handleController() {
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _ellapsedSeconds = widget.controller.ellapsedSeconds;
        });
      }
    });
  }

  @override
  void initState() {
    _handleController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final minutesString = (_ellapsedSeconds / 60).truncate().toString().padLeft(2, "0");
    final secondsString = (_ellapsedSeconds % 60).toString().padLeft(2, "0");

    return Text(
      "$minutesString:$secondsString",
      style: widget.style ?? Theme.of(context).textTheme.headline4,
    );
  }
}
