
import 'package:dlinks/architecture/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'BaseViewModel.dart';

/// Full screen widget only
abstract class BaseView extends BaseWidget {
  const BaseView({Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget, BaseViewModel> getWidgetState() {
    return getViewState();
  }

  BaseViewState getViewState();
}

abstract class BaseViewState<T extends BaseView, V extends BaseViewModel>
    extends BaseWidgetState<T, V> {

  @override
  void onWidgetModelReady() {

    onViewModelReady();
  }

  void showSnackbarInfo(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2500),
        content: Text(message,
            style: const TextStyle(fontSize: 16, color: Colors.white))));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onViewModelReady();

  bool get shouldUseBranchIoSdk => true;
}
