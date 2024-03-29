import 'package:dlinks/features/home/HomeViewModel.dart';
import 'package:dlinks/features/home/tabview_widget/AccountTabViewModel.dart';
import 'package:dlinks/features/home/tabview_widget/ContactTabViewModel.dart';
import 'package:dlinks/features/home/tabview_widget/MessageTabViewModel.dart';
import 'package:dlinks/utils/error_manager/ErrorLogger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/LocalCacheService.dart';
import '../download_manager/DownloadManagerViewModel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel viewModel = Get.put(HomeViewModel());

  @override
  void initState() {
    super.initState();

    // Get.put(MessageTabViewModel());
    // Get.put(ContactTabViewModel());
    // Get.put(DownloadManagerViewModel());
    // Get.put(AccountTabViewModel());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => viewModel.getBody()),
      bottomNavigationBar: Theme(
        data: ThemeData(splashColor: Colors.transparent),
        child: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            currentIndex: viewModel.currentTab.value,
            onTap: (index) {
              viewModel.changeTab(index);
            },
            items: const [
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.message),
                label: 'Message',
              ),
              // BottomNavigationBarItem(
              //   backgroundColor: Colors.black,
              //   icon: Icon(Icons.call),
              //   label: 'Call',
              // ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.contact_page),
                label: 'Contact',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.folder),
                label: 'File',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),

            ],
          ),
        ),
      ),
    );
  }
}
