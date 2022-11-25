import 'package:dlinks/utils/error_manager/ErrorLogger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler(
      {required this.resumeCallBack, required this.detachedCallBack});

  final AsyncCallback resumeCallBack;
  final AsyncCallback detachedCallBack;

//  @override
//  Future<bool> didPopRoute()

//  @override
//  void didHaveMemoryPressure()

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        logWarning('App inactive.');
        await detachedCallBack();
        break;
      case AppLifecycleState.paused:
        // logWarning('App paused.');
        // await detachedCallBack;
        break;
      case AppLifecycleState.detached:
        logWarning('App detached.');
        await detachedCallBack();
        break;
      case AppLifecycleState.resumed:
        logWarning('App resumed.');
        await resumeCallBack();
        break;
    }
    logWarning('''
=============================================================
               $state
=============================================================
''');
  }

//  @override
//  void didChangeLocale(Locale locale)

//  @override
//  void didChangeTextScaleFactor()

//  @override
//  void didChangeMetrics();

//  @override
//  Future<bool> didPushRoute(String route)
}
