import 'package:dlinks/architecture/BaseWidget.dart';
import 'package:dlinks/architecture/BaseWidgetModel.dart';
import 'package:flutter/material.dart';

import 'ContactTabViewModel.dart';

class ContactTabView extends BaseWidget {
  final ContactTabViewModel model;

  const ContactTabView(this.model, {Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget, BaseWidgetModel> getWidgetState() {
    return _ContactTabViewState();
  }
}

class _ContactTabViewState
    extends BaseWidgetState<ContactTabView, ContactTabViewModel> {
  @override
  Widget getView() {
    return const Scaffold(body: Center(child: Text('Contact')));
  }

  @override
  ContactTabViewModel getViewModel() {
    return widget.model;
  }

  @override
  void onWidgetModelReady() {
  }
}
