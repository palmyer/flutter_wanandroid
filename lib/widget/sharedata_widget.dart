import 'package:flutter/material.dart';

class ShareDataWidget extends InheritedWidget {
  final bool data;

  ShareDataWidget(this.data, {@required Widget child}) : super(child: child);

  static ShareDataWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShareDataWidget>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
