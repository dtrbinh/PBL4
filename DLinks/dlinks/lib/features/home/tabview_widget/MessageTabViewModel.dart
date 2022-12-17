import 'package:dlinks/data/repository/UserRepository.dart';
import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:get/get.dart';

class MessageTabViewModel extends GetxController {
  UserRepository c = Get.find<UserRepository>();
  Rx<bool> isLoading = true.obs;
  RxList userInbox = [].obs;

  Future<void> initData() async {
    // userInbox.value = [];
    userInbox.value = await CloudFirestoreService()
        .getAllChatDialog(c.userProvider.value.currentUser!.uid);
    // TODO: fix send myself message
    userInbox.value.removeWhere(
        (element) => element.uid == c.userProvider.value.currentUser!.uid);
    isLoading.value = false;
  }
}
