import 'package:flutter/material.dart';

class ShareDataWidget<T> extends InheritedWidget {
  T _data;

  ShareDataWidget(this._data, Widget child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
