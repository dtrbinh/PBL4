import 'package:dlinks/features/chat_screen/ChatScreenViewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/Message.dart';

class ChatScreenView extends StatefulWidget {
  final String senderUid;

  const ChatScreenView(this.senderUid, {Key? key}) : super(key: key);

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  final viewModel = Get.put(ChatScreenViewModel());

  @override
  void initState() {
    viewModel.initChatDialog(widget.senderUid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(viewModel
                          .chatFriend.value.photoURL ??
                      'https://icon-library.com/images/no-user-image-icon/no-user-image-icon-27.jpg'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(viewModel.chatFriend.value.displayName ?? '...'),
              ],
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          Expanded(
            child: Obx(
              () => ListView(
                children: viewModel.inbox.value
                    .messageBox //TODO: chỉ chọn ra những tin nhắn của người gửi có uid = senderUid tương ứng, hiện tại là tất cả tin nhắn từ những người khác nhau đều hiển thị
                    .map((e) => _messageCard(e))
                    .toList(),
              ),
            ),
          ),
          sendBox(),
        ]),
      ),
    );
  }

  Widget sendBox() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Obx(
                () => TextFormField(
                  controller: viewModel.messageController.value,
                  decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black45, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                ),
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              // viewModel.sendMessage(widget.senderUid);
            },
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }

  Widget _messageCard(dynamic e) {
    bool isMe = e.senderUid != viewModel.chatFriend.value.uid;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Obx(
        () => Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Visibility(
              visible: !isMe,
              child: CircleAvatar(
                radius:15,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(viewModel
                        .chatFriend.value.photoURL ??
                    'https://icon-library.com/images/no-user-image-icon/no-user-image-icon-27.jpg'),
              ),
            ),
            GetBuilder<ChatScreenViewModel>(builder: (controller) {
              return viewModel.getMessageBlock(e);
            }),
            Visibility(
              visible: isMe,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(viewModel
                        .chatFriend.value.photoURL ??
                    'https://icon-library.com/images/no-user-image-icon/no-user-image-icon-27.jpg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
