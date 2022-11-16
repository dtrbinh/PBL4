import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:get/get.dart';

class MessageTabViewModel extends GetxController {
  UserProvider c = Get.find<UserProvider>();

  RxList userInbox = [].obs;

  Future<void> initData() async {
    userInbox.value = await c.authProvider.value.firebaseService
        .getAllUserChatWithMe(c.userRepository.value.currentUser!.uid);
  }
}
