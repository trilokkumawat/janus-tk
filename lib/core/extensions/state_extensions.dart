import 'package:flutter/material.dart';

mixin SafeStateMixin<T extends StatefulWidget> on State<T> {
  bool safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
      return true;
    }
    return false;
  }
}

extension SafeStateExtension<T extends StatefulWidget> on State<T> {
  bool safeSetState(VoidCallback fn) {
    if (mounted) {
      (this as dynamic).setState(fn);
      return true;
    }
    return false;
  }
}
