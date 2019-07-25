# wait_completer

Future can handle cancelable wait utility

## Usage

```dart

final completer = WaitCompleter(duration: Duration(milliseconds: 2000));
main() async {
  Timer(Duration(milliseconds: 1000), ()=> completer.cance());
  final result = await completer.start();
  if(result == WaitCompleterStatus.complete) {
    print('complete');
  }
  else if(result == WaitCompleterStatus.canceled) {
    print('canceled');
  }
}

```


## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
