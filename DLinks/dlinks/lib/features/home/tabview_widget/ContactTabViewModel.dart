import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../architecture/BaseWidgetModel.dart';
import '../../../data/model/ChatUser.dart';
import '../../../data/provider/UserProvider.dart';

class ContactTabViewModel extends BaseWidgetModel {
  TextEditingController textEditingController = TextEditingController();
  List<ChatUser> contacts = [];

  Future<void> getContact(BuildContext context) async {
    contacts = await context
        .read<UserProvider>()
        .authProvider
        .firebaseService
        .getAllChatUser();
    notifyListeners();
  }
}
