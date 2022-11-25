import 'package:dlinks/utils/error_manager/ErrorLogger.dart';
import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler(
      {required this.resumeCallBack, required this.detachedCallBack});

  final VoidCallback? resumeCallBack;
  final VoidCallback? detachedCallBack;

//  @override
//  Future<bool> didPopRoute()

//  @override
//  void didHaveMemoryPressure()

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        // await detachedCallBack;
        break;
      case AppLifecycleState.paused:
        detachedCallBack;
        break;
      case AppLifecycleState.detached:
        detachedCallBack;
        break;
      case AppLifecycleState.resumed:
        resumeCallBack;
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
