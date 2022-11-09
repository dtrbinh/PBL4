import 'package:dlinks/architecture/BaseWidget.dart';
import 'package:dlinks/architecture/BaseWidgetModel.dart';
import 'package:flutter/material.dart';

import 'AccountTabViewModel.dart';

class AccountTabView extends BaseWidget {
  final model = AccountTabViewModel();

  AccountTabView({Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget, BaseWidgetModel> getWidgetState() {
    return _AccountTabViewState();
  }
}

class _AccountTabViewState
    extends BaseWidgetState<AccountTabView, AccountTabViewModel> {
  @override
  Widget getView() {
    return const Scaffold(body: Center(child: Text('Account')));
  }

  @override
  AccountTabViewModel getViewModel() {
    return widget.model;
  }

  @override
  void onWidgetModelReady() {
    // TODO: implement onWidgetModelReady
  }
}
