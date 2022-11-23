import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:get/get.dart';

class MessageTabViewModel extends GetxController {
  UserProvider c = Get.find<UserProvider>();
  Rx<bool> isLoading = true.obs;
  RxList userInbox = [].obs;

  Future<void> initData() async {
    userInbox.value = await CloudFirestoreService()
        .getAllUserChatWithMe(c.userRepository.value.currentUser!.uid);
    // userInbox.value.
    userInbox.value.removeWhere(
        (element) => element.uid == c.userRepository.value.currentUser!.uid);
    isLoading.value = false;
  }
}
