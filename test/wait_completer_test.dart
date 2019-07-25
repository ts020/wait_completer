import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:wait_completer/wait_completer.dart';

void main() {
  test('normal', () async {
    final completer = WaitCompleter();
    completer.start();
    expect(await completer.future, WaitCompleterStatus.complete);
    expect(completer.status, WaitCompleterStatus.complete);
  });

  test('cancel', () {
    final completer = WaitCompleter(autoStart: true);
    Timer(Duration(milliseconds: 0), () => completer.cancel());
    expect(completer.future, completion(equals(WaitCompleterStatus.canceled)));
    expect(completer.status, WaitCompleterStatus.progress);
  });

  test('cancel await', () async {
    final completer = WaitCompleter();
    completer.start();
    Timer(Duration(milliseconds: 0), () => completer.cancel());
    expect(await completer.future, WaitCompleterStatus.canceled);
    expect(completer.isCanceled, true);
  });

  test('serial', () async {
    final completer1 = WaitCompleter(autoStart: true);

    expect(completer1.future, completion(equals(WaitCompleterStatus.complete)));
    await completer1.future;
    expect(completer1.isComplete, true);
    expect(completer1.isCanceled, false);

    final completer2 = WaitCompleter(autoStart: true);
    expect(completer2.future, completion(equals(WaitCompleterStatus.canceled)));
    Timer.run(() => completer2.cancel());
    expect(completer2.status, WaitCompleterStatus.progress);
    await completer2.future;
    expect(completer2.isCanceled, true);

    final completer3 = WaitCompleter(autoStart: true);
    final completer4 = WaitCompleter(autoStart: true);

    expect(completer3.future, completion(equals(WaitCompleterStatus.complete)));

    expect(completer4.future, completion(equals(WaitCompleterStatus.canceled)));
    Timer.run(() => completer4.cancel());
  });

  test('Timing shift', () async {
    final completer1 = WaitCompleter(duration: Duration(milliseconds: 40));
    expect(completer1.status, WaitCompleterStatus.idle);
    Timer(Duration(milliseconds: 20), () => completer1.cancel());
    final result = completer1.start();
    expect(completer1.status, WaitCompleterStatus.progress);
    expect(await result, WaitCompleterStatus.canceled);
    expect(completer1.status, WaitCompleterStatus.canceled);

    final completer2 = WaitCompleter(duration: Duration(milliseconds: 30));
    Timer(Duration(milliseconds: 20), () => completer2.cancel());
    expect(await completer2.start(), WaitCompleterStatus.canceled);

    final completer3 = WaitCompleter(duration: Duration(milliseconds: 21));
    Timer(Duration(milliseconds: 20), () => completer3.cancel());
    expect(await completer3.start(), WaitCompleterStatus.canceled);

    final completer4 = WaitCompleter(duration: Duration(milliseconds: 20));
    Timer(Duration(milliseconds: 20), () => completer4.cancel());
    expect(await completer4.start(), WaitCompleterStatus.canceled);

    final completer5 = WaitCompleter(duration: Duration(milliseconds: 19));
    Timer(Duration(milliseconds: 20), () => completer5.cancel());
    expect(await completer5.start(), WaitCompleterStatus.complete);
  });

  test('example', () async {
    final completer = WaitCompleter(duration: Duration(seconds: 2));
    Timer(Duration(milliseconds: 300), () => completer.cancel());
    final status = await completer.start();
    if (status == WaitCompleterStatus.complete) {
      print('compete');
    } else {
      print('canceled');
    }
    expect(completer.status, WaitCompleterStatus.canceled);
  });
}
