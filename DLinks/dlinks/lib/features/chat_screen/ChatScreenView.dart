import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dlinks/data/repository/UserRepository.dart';
import 'package:dlinks/features/chat_screen/ChatScreenViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    viewModel.initSpeech();
    viewModel.initChatDialog(myUid, widget.theirUid);
    viewModel.scrollDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        leadingWidth: 40,
        backgroundColor: Colors.black,
        title: Obx(() => Row(
              children: [
                Stack(children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(viewModel
                            .their.value.photoURL ??
                        'https://icon-library.com/images/no-user-image-icon/no-user-image-icon-27.jpg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: (viewModel.their.value.status ?? false)
                              ? Colors.green
                              : Colors.grey,
                          shape: BoxShape.circle,
                          border: const Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 2))),
                    ),
                  )
                ]),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.their.value.displayName ?? '...',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.clip),
                      ),
                      Text(
                        (viewModel.their.value.status ?? false)
                            ? 'Đang hoạt động'
                            : DateTime.now()
                                        .difference(
                                            (viewModel.their.value.lastSeen ??
                                                    Timestamp.now())
                                                .toDate())
                                        .inDays >
                                    0
                                ? 'Hoạt động ${DateTime.now().difference((viewModel.their.value.lastSeen ?? Timestamp.now()).toDate()).inDays} ngày trước'
                                : DateTime.now()
                                            .difference((viewModel
                                                        .their.value.lastSeen ??
                                                    Timestamp.now())
                                                .toDate())
                                            .inHours >
                                        0
                                    ? 'Hoạt động ${DateTime.now().difference((viewModel.their.value.lastSeen ?? Timestamp.now()).toDate()).inHours} giờ trước'
                                    : 'Hoạt động ${DateTime.now().difference((viewModel.their.value.lastSeen ?? Timestamp.now()).toDate()).inMinutes} phút trước',
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
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
                      children: <Widget>[
                            Obx(
                              () => Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(viewModel
                                                  .their.value.photoURL ??
                                              'https://icon-library.com/images/no-user-image-icon/no-user-image-icon-27.jpg'),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        viewModel.their.value.displayName ??
                                            '...',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      //join at
                                      Text(
                                        'Tham gia vào ${DateFormat('dd/MM/yyyy').format((viewModel.their.value.createdAt ?? Timestamp.now()).toDate())}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  )),
                            ),
                          ] +
                          viewModel.inbox.value
                              .map((e) => _messageCard(e))
                              .toList(),
                    ),
                  )),
            ),
            sendBox(),
          ]),
        ),
      ),
    );
  }

  Widget sendBox() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        children: [
          GetBuilder<ChatScreenViewModel>(
            builder: (controller) => Visibility(
                visible: viewModel.isUploading.value,
                child: LinearProgressIndicator(
                  value: viewModel.uploadProgress.value,
                  backgroundColor: Colors.grey,
                  color: Colors.blue,
                  minHeight: 2,
                )),
          ),
          Slidable(
            startActionPane: ActionPane(
              dragDismissible: false,
              extentRatio: 0.6,
              motion: const ScrollMotion(),
              children: [
                _sendFileComponent(),
                _sendAudioComponent(),
                _sendVideoComponent(),
                _sendImageComponent(),
                _speechToTextComponent(),
              ],
            ),
            child: Builder(
              builder: (BuildContext slidableContext) {
                return Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (Slidable.of(slidableContext)!
                              .enableStartActionPane) {
                            Slidable.of(slidableContext)?.openStartActionPane();
                          } else {}
                        },
                        icon: const Icon(Icons.add)),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.only(right: 16),
                        child: TextField(
                          onTap: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 200), () {
                              viewModel.scrollDown();
                            });
                          },
                          minLines: 1,
                          maxLines: 5,
                          controller: viewModel.messageController,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              suffixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  viewModel.sendMessage(
                                      viewModel.messageController.value.text);
                                  viewModel.messageController.text = '';
                                },
                                icon: const Icon(Icons.send),
                              ),
                              hintText: "Type a message",
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)))),
                          onSubmitted: (content) {
                            viewModel.sendMessage(content);
                            viewModel.messageController.text = '';
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    viewModel.messageController.dispose();
    viewModel.scrollController.dispose();
    viewModel.audioPlayer.value.stop();
    viewModel.audioPlayer.value.dispose();
    viewModel.speechToText.cancel();
    viewModel.endMessageStream();
    viewModel.endTheirUserStream();
    super.dispose();
  }

  Widget _sendImageComponent() {
    return SlidableAction(
      onPressed: (context) async {
        await viewModel.sendImage();
      },
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      icon: Icons.image,
    );
  }

  Widget _sendVideoComponent() {
    return SlidableAction(
      onPressed: (context) async {
        await viewModel.sendVideo();
      },
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      icon: Icons.video_collection,
    );
  }

  Widget _sendAudioComponent() {
    return SlidableAction(
      onPressed: (context) async {
        await viewModel.sendAudio();
      },
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      icon: Icons.audio_file,
    );
  }

  Widget _sendFileComponent() {
    return SlidableAction(
      onPressed: (context) {
        viewModel.sendFile();
      },
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      icon: Icons.file_upload,
    );
  }

  Widget _speechToTextComponent() {
    return SlidableAction(
      onPressed: (context) {
        Get.dialog(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) =>
                GestureDetector(
              onTap: () {
                Get.back();
              },
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 1,
                contentPadding: EdgeInsets.only(top: Get.height / 2),
                content: GestureDetector(
                  onTapDown: (details) {
                    setState(() {});
                    if (viewModel.speechToText.isNotListening) {
                      viewModel.startListening();
                    } else {
                      viewModel.stopListening();
                    }
                  },
                  onTapUp: (details) {
                    setState(() {});
                    if (viewModel.speechToText.isListening) {
                      viewModel.stopListening();
                      Get.back();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Press and hold to speak',
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: viewModel.isSpeech.value
                                  ? Colors.blue[300]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.mic,
                            color: Colors.grey,
                            size: 24,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          barrierColor: Colors.transparent,
        );
      },
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      icon: Icons.mic,
    );
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
