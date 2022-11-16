// ignore_for_file: file_names

import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

class DLinksApplication extends StatelessWidget {
  const DLinksApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Get.put(UserProvider());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DUT Links',
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
