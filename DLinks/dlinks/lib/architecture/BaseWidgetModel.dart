import 'dart:async';

import 'package:flutter/material.dart';

class BaseWidgetModel extends ChangeNotifier {

  StreamController<dynamic> errorController = StreamController.broadcast();

  void onError(dynamic error) {
    errorController.add(error);
    debugPrint('---------------Internal error: $error');
  }

  bool isLoading = true;

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }
}
