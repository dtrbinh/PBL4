import 'package:dlinks/utils/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'SplashViewModel.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SplashViewModel viewModel = Get.put(SplashViewModel());
    viewModel.initAppData();
    return Scaffold(
      body: Container(
        color: AppColor.BACKGROUND_WHITE,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCircle(
              size: MediaQuery.of(context).size.width / 5,
              color: AppColor.BLACK,
            ),
          ],
        ),
      ),
    );
  }
}
