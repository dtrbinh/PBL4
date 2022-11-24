import 'package:dlinks/data/repository/UserRepository.dart';
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
  final myUid = Get.find<UserRepository>().userProvider.value.currentUser!.uid;

  @override
  void initState() {
    viewModel.initChatDialog(myUid, widget.theirUid);
    viewModel.scrollDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leadingWidth: 30,
        backgroundColor: Colors.black,
        title: Obx(() => Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(viewModel
                          .their.value.photoURL ??
                      'https://icon-library.com/images/no-user-image-icon/no-user-image-icon-27.jpg'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    viewModel.their.value.displayName ?? 'Chatting with ...',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              ))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          color: Colors.white,
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                  controller: viewModel.scrollController,
                  child: Obx(
                    () => Column(
                      children: viewModel.inbox.value
                          .map((e) => _messageCard(e))
                          .toList(),
                    ),
                  )
                  // StreamBuilder(
                  //   stream: viewModel.messageStream,
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                  //           snapshot) {
                  //     if (!snapshot.hasData) {
                  //       return const LinearProgressIndicator(color: Colors.black, backgroundColor: Colors.grey,);
                  //     }
                  //     debugPrint(snapshot.data!.data().toString());
                  //     viewModel.inbox.value =
                  //         Inbox.fromMap(snapshot.data!.data() ?? {});
                  //     viewModel.filterMessage();
                  //     return Obx(
                  //       () => Column(
                  //         children: viewModel.dialog.value
                  //             .map((e) => _messageCard(e))
                  //             .toList(),
                  //       ),
                  //     );
                  //   },
                  // )
                  ),
            ),
            sendBox(),
          ]),
        ),
      ),
    );
  }

  Widget sendBox() {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.only(right: 16),
            child: TextField(
              onTap: () async {
                await Future.delayed(const Duration(milliseconds: 200), () {
                  viewModel.scrollDown();
                });
              },
              minLines: 1,
              maxLines: 5,
              controller: viewModel.messageController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      viewModel
                          .sendMessage(viewModel.messageController.value.text);
                      viewModel.messageController.text = '';
                    },
                    icon: const Icon(Icons.send),
                  ),
                  hintText: "Type a message",
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
              onSubmitted: (content) {
                viewModel.sendMessage(content);
                viewModel.messageController.text = '';
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    viewModel.messageController.dispose();
    viewModel.scrollController.dispose();
    viewModel.audioPlayer.value.stop();
    viewModel.audioPlayer.value.dispose();
    viewModel.endStream();
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
                  backgroundImage: NetworkImage(Get.find<UserRepository>()
                      .userProvider
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
