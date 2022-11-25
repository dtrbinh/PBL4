import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:dlinks/features/home/tabview_widget/AccountTabView.dart';
import 'package:dlinks/features/home/tabview_widget/CallTabView.dart';
import 'package:dlinks/features/home/tabview_widget/CallTabViewModel.dart';
import 'package:dlinks/features/home/tabview_widget/ContactTabView.dart';
import 'package:dlinks/features/home/tabview_widget/MessageTabView.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/services/LocalCacheService.dart';

class HomeViewModel extends GetxController {

  final CallTabViewModel callTabViewModel = CallTabViewModel();

  RxInt currentTab = 0.obs;
  void changeTab(int index) {
    currentTab.value = index;
  }

  Widget getBody() {
    switch (currentTab.value) {
      case 0:
        return const MessageTabView();
      case 1:
        return CallTabView(callTabViewModel);
      case 2:
        return const ContactTabView();
      case 3:
        return const AccountTabView();
      default:
        return const MessageTabView();
    }
  }

  void setOnline(String myUid) {
    LocalCacheService.setBool('status', true);
    CloudFirestoreService().setChatUserStatus(myUid, true);
  }

}