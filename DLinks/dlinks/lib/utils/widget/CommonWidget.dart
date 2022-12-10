import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// function show loading dialog
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        child: SpinKitFadingCircle(
          color: Colors.white,
          size: 50.0,
        ),
      );
    },
  );
}

// function hide loading dialog if it open
void hideLoadingDialog(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}