import 'package:dlinks/architecture/BaseView.dart';
import 'package:dlinks/architecture/BaseViewModel.dart';
import 'package:dlinks/features/splash/SplashViewModel.dart';
import 'package:dlinks/utils/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
        color: AppColor.BACKGROUND_WHITE,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: MediaQuery.of(context).size.height/5,),
            viewModel.isLoading
                ? SpinKitSpinningLines(
                    lineWidth: 5,
                    size: MediaQuery.of(context).size.width/5,
                    itemCount: 10,
                    color: AppColor.BLACK,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  @override
  SplashViewModel getViewModel() {
    return SplashViewModel();
  }

  @override
  void onViewModelReady() {
    viewModel.initAppData(context);
  }
}
