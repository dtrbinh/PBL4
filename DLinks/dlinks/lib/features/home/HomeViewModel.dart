import 'package:dlinks/architecture/BaseViewModel.dart';
import 'package:dlinks/features/home/tabview_widget/AccountTabView.dart';
import 'package:dlinks/features/home/tabview_widget/AccountTabViewModel.dart';
import 'package:dlinks/features/home/tabview_widget/CallTabView.dart';
import 'package:dlinks/features/home/tabview_widget/CallTabViewModel.dart';
import 'package:dlinks/features/home/tabview_widget/ContactTabView.dart';
import 'package:dlinks/features/home/tabview_widget/ContactTabViewModel.dart';
import 'package:dlinks/features/home/tabview_widget/MessageTabView.dart';
import 'package:dlinks/features/home/tabview_widget/MessageTabViewModel.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends BaseViewModel {

  final MessageTabViewModel messageTabViewModel = MessageTabViewModel();
  final CallTabViewModel callTabViewModel = CallTabViewModel();
  final ContactTabViewModel contactTabViewModel = ContactTabViewModel();
  final AccountTabViewModel accountTabViewModel = AccountTabViewModel();

  int currentTab = 0;
  void changeTab(int index) {
    currentTab = index;
    notifyListeners();
  }

  Widget getBody() {
    switch (currentTab) {
      case 0:
        return MessageTabView(messageTabViewModel);
      case 1:
        return CallTabView(callTabViewModel);
      case 2:
        return ContactTabView(contactTabViewModel);
      case 3:
        return AccountTabView(accountTabViewModel);
      default:
        return MessageTabView(messageTabViewModel);
    }
  }

}