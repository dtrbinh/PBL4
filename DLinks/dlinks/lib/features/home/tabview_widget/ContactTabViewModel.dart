import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/repository/UserRepository.dart';

class ContactTabViewModel extends GetxController {
  final UserRepository c = Get.find<UserRepository>();
  Rx<TextEditingController> textEditingController = TextEditingController().obs;
  RxList contacts = [].obs;

  Future<void> getContact() async {
    contacts.value =
        await CloudFirestoreService().getAllChatUser();
    contacts.value.removeWhere(
        (element) => element.uid == c.userProvider.value.currentUser!.uid);
  }
}
