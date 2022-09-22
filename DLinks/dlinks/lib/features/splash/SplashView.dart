// ignore_for_file: unnecessary_const

import 'package:dlinks/architecture/BaseView.dart';
import 'package:dlinks/architecture/BaseViewModel.dart';
import 'package:dlinks/features/splash/SplashViewModel.dart';
import 'package:dlinks/utils/AppColor.dart';
import 'package:flutter/material.dart';

class SplashView extends BaseView {
  const SplashView({Key? key}) : super(key: key);

  @override
  BaseViewState<BaseView, BaseViewModel> getViewState() {
    return _SplashViewState();
  }
}

class _SplashViewState extends BaseViewState<SplashView, SplashViewModel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget getView() {
    return Scaffold(
      body: Container(
        color: AppColor.PURPLE_1,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Center(
            child: CircularProgressIndicator(
          color: AppColor.ORANGE_1,
        )),
      ),
    );
  }

  @override
  SplashViewModel getViewModel() {
    return SplashViewModel();
  }

  @override
  void onViewModelReady() {}
}
