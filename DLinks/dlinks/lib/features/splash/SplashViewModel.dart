import 'package:dlinks/data/repository/UserRepository.dart';
import 'package:dlinks/data/services/LocalCacheService.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashViewModel extends GetxController {
  void initAppData() async {
    await requestNeededPermission();
    quickLogin();
  }

  Future<void> requestNeededPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      // Permission.camera, //
      Permission.microphone,
      // Permission.photos, //
      // Permission.mediaLibrary, //
      Permission.notification,
      Permission.manageExternalStorage,
    ].request();

    for (var i in statuses.entries) {
      if (i.value.isDenied) {
        await i.key.request();
      }
    }
    // await Permission.storage.status.then((value) async {
    //   value.isGranted ? {} : {await Permission.storage.request()};
    // });
    // await Permission.microphone.status.then((value) async {
    //   value.isGranted ? {} : {await Permission.microphone.request()};
    // });
    // await Permission.manageExternalStorage.status.then((value) async {
    //   value.isGranted ? {} : {await Permission.manageExternalStorage.request()};
    // });
  }

  void quickLogin() {
    LocalCacheService.getBool('isLogin').then((value) {
      if (value == true) {
        Get.find<UserRepository>().authService.value.handleSignIn().then((value) {
          if (value != null) {
            Get.find<UserRepository>().userProvider.value.currentUser = value;
            Get.offAllNamed(AppRoute.home);
          } else {
            Get.offAllNamed(AppRoute.signin);
          }
        });
      } else {
        Get.offAllNamed(AppRoute.signin);
      }
    });
  }
}
