import 'dart:async';

import 'package:flutter_debouncer/flutter_debouncer.dart';

mixin ThrollService {
  final throll = Throttler();

  void throttleFunction(Function() action) {
    throll.throttle(
        duration: const Duration(milliseconds: 500), onThrottle: action);
  }

  // StreamSubscription<dynamic> throttleSubscriptions( StreamSubscription Function() action) {
  //   throll.throttle(
  //       duration: const Duration(milliseconds: 500), onThrottle: action);

  //   return action;
  // }
}

mixin DebounceService {
  final debouncer = Debouncer();

  void debounceFunction(Function() action) {
    debouncer.debounce(
        duration: const Duration(milliseconds: 500), onDebounce: action);
  }
}
