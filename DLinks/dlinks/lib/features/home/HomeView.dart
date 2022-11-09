import 'package:dlinks/architecture/BaseView.dart';
import 'package:dlinks/architecture/BaseViewModel.dart';
import 'package:dlinks/features/home/HomeViewModel.dart';
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
      body: viewModel.getBody(),
      bottomNavigationBar: Theme(
        data: ThemeData(
            splashColor: Colors.transparent),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: viewModel.currentTab,
          onTap: (index) {
            viewModel.changeTab(index);
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.message),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.call),
              label: 'Call',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.contact_page),
              label: 'Contact',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
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
