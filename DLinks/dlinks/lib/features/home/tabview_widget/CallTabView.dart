import 'package:dlinks/architecture/BaseWidget.dart';
import 'package:dlinks/architecture/BaseWidgetModel.dart';
import 'package:flutter/material.dart';

import 'CallTabViewModel.dart';

class CallTabView extends BaseWidget {
  final CallTabViewModel model;

  const CallTabView(this.model, {Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget, BaseWidgetModel> getWidgetState() {
    return _CallTabViewState();
  }
}

class _CallTabViewState
    extends BaseWidgetState<CallTabView, CallTabViewModel> {
  @override
  Widget getView() {
    return const Scaffold(body: Center(child: Text('Call')));
  }

  @override
  CallTabViewModel getViewModel() {
    return widget.model;
  }

  @override
  void onWidgetModelReady() {
  }
}
