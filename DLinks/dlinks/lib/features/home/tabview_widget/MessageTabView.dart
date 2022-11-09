import 'package:dlinks/architecture/BaseWidget.dart';
import 'package:dlinks/architecture/BaseWidgetModel.dart';
import 'package:flutter/material.dart';

import 'MessageTabViewModel.dart';

class MessageTabView extends BaseWidget {
  final MessageTabViewModel model;

  const MessageTabView(this.model, {Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget, BaseWidgetModel> getWidgetState() {
    return _MessageTabViewState();
  }
}

class _MessageTabViewState
    extends BaseWidgetState<MessageTabView, MessageTabViewModel> {
  @override
  Widget getView() {
    return const Scaffold(body: Center(child: Text('Message')));
  }

  @override
  MessageTabViewModel getViewModel() {
    return widget.model;
  }

  @override
  void onWidgetModelReady() {
  }
}
