import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:dlinks/features/chat_screen/ChatScreenViewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreenView extends StatefulWidget {
  final String theirUid;

  const ChatScreenView(this.theirUid, {Key? key}) : super(key: key);

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  final viewModel = Get.put(ChatScreenViewModel());

  @override
  void initState() {
    viewModel.initChatDialog(widget.theirUid);
    viewModel.scrollDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Obx(() => Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(viewModel
                          .their.value.photoURL ??
                      'https://icon-library.com/images/no-user-image-icon/no-user-image-icon-27.jpg'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(viewModel.their.value.displayName ?? '...'),
              ],
            )),
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
              () => SingleChildScrollView(
                controller: viewModel.scrollController.value,
                child: Column(
                  children: viewModel.dialog.value
                      .map((e) => _messageCard(e))
                      .toList(),
                ),
              ),
            ),
          ),
          sendBox(),
        ]),
      ),
    );
  }

  Widget sendBox() {
    return Row(
      children: [
        IconButton(onPressed: (){}, icon: Icon(Icons.add)),
        Expanded(
          child: Container(
            color: Colors.white,
            height: 70,
            padding: const EdgeInsets.symmetric( vertical: 10),
            child: TextField(
              controller: viewModel.messageController,
              decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
              // onChanged: (value) {
              //   viewModel.messageController.text = value;
              // },
              onSubmitted: (content) {
                viewModel.sendMessage(content);
                viewModel.messageController.text = '';
                Get.back(canPop: false);
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            viewModel.sendMessage(viewModel.messageController.value.text);
            // setState((){});
            viewModel.messageController.text = '';
            FocusManager.instance.primaryFocus?.unfocus();
          },
          icon: const Icon(Icons.send),
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    viewModel.audioPlayer.value.stop();
    viewModel.audioPlayer.value.dispose();
    // viewModel.endStream();
    super.dispose();
  }

  Widget _messageCard(dynamic e) {
    bool isMe = e.senderUid != viewModel.their.value.uid;
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
                radius: 15,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(viewModel.their.value.photoURL ??
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
                  backgroundImage: NetworkImage(Get.find<UserProvider>()
                      .userRepository
                      .value
                      .currentUser!
                      .photoURL!),
                )),
          ],
        ),
      ),
    );
  }
}
