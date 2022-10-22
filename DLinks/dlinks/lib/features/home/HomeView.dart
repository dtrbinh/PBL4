import 'package:dlinks/architecture/BaseView.dart';
import 'package:dlinks/architecture/BaseViewModel.dart';
import 'package:dlinks/features/home/HomeViewModel.dart';
import 'package:dlinks/utils/AppColor.dart';
import 'package:flutter/material.dart';

class HomeView extends BaseView {
  const HomeView({Key? key}) : super(key: key);

  @override
  BaseViewState<BaseView, BaseViewModel> getViewState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends BaseViewState<HomeView, HomeViewModel> {
  @override
  Widget getView() {
    return Scaffold(
      body: Container(
        color: AppColor.BACKGROUND_CREAM,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: Text('Home'),
        ),
      ),
    );

  }

  @override
  HomeViewModel getViewModel() {
    return HomeViewModel();
  }

  @override
  void onViewModelReady() {}
}
