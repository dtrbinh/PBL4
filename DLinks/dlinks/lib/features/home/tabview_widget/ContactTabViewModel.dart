import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/provider/UserProvider.dart';

class ContactTabViewModel extends GetxController {
  final UserProvider c = Get.find<UserProvider>();
  Rx<TextEditingController> textEditingController = TextEditingController().obs;
  RxList contacts = [].obs;

  Future<void> getContact() async {
    contacts.value =
        await CloudFirestoreService().getAllChatUser();
  }
}
