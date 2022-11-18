import 'package:dlinks/utils/RouteManager.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashViewModel extends GetxController {
  void initAppData() async {
    await Future<void>.delayed(const Duration(milliseconds: 3000))
        .then((value) => Get.offNamed(AppRoute.signin));
    Permission.storage.status.then((value) async {
      value.isGranted ? {} : {await Permission.storage.request()};
    });
    Permission.manageExternalStorage.status.then((value) async {
      value.isGranted ? {} : {await Permission.storage.request()};
    });
  }
}
