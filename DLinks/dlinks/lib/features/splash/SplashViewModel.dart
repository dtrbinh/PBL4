import 'package:dlinks/utils/RouteManager.dart';
import 'package:get/get.dart';

class SplashViewModel extends GetxController {
  void initAppData() async {
    await Future<void>.delayed(const Duration(milliseconds: 3000))
        .then((value) => Get.offNamed(AppRoute.signin));
  }
}
