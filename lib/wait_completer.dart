library wait_completer;

import 'dart:async';

const Duration defaultDuration = Duration(milliseconds: 100);

class WaitCompleter {
  final Completer<WaitCompleterStatus> _completer;
  final Duration duration;
  WaitCompleterStatus _status;
  Timer _timer;

  WaitCompleter({
    this.duration = defaultDuration,
    bool autoStart = false,
  }) : _completer = Completer<WaitCompleterStatus>() {
    _status = WaitCompleterStatus.idle;
    if (autoStart) {
      start();
    }
  }

  Future<WaitCompleterStatus> start() {
    _status = WaitCompleterStatus.progress;
    _timer = Timer(duration, () {
      _status = WaitCompleterStatus.complete;
      _completer.complete(WaitCompleterStatus.complete);
    });
    return future;
  }

  WaitCompleterStatus get status => _status;
  bool get isComplete => _status == WaitCompleterStatus.complete;
  bool get isCanceled => _status == WaitCompleterStatus.canceled;
  Future<WaitCompleterStatus> get future => _completer.future;

  void cancel() {
    if (_completer.isCompleted || _timer == null) return;
    _status = WaitCompleterStatus.canceled;
    _timer.cancel();
    _completer.complete(WaitCompleterStatus.canceled);
  }
}

enum WaitCompleterStatus {
  idle,
  progress,
  canceled,
  complete,
}
