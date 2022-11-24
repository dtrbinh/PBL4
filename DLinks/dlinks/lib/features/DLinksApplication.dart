// ignore_for_file: file_names

import 'package:dlinks/data/repository/UserRepository.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DLinksApplication extends StatelessWidget {
  const DLinksApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserRepository());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DLinks',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Nunito',
        useMaterial3: true,
      ),
      initialRoute: AppRoute.splash,
      onGenerateRoute: AppRoute.onGenerateRoute,
    );
  }
}
