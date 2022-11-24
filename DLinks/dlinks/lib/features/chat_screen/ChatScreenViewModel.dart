import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dlinks/data/model/Message.dart';
import 'package:dlinks/data/repository/UserRepository.dart';
import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:dlinks/features/home/tabview_widget/MessageTabViewModel.dart';
import 'package:dlinks/utils/error_manager/ErrorLogger.dart';
import 'package:dlinks/utils/widget/DownloadManager.dart';
import 'package:dlinks/utils/widget/VideoPlayerView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/model/AudioMessage.dart';
import '../../data/model/ChatUser.dart';
import '../../data/model/FileMessage.dart';
import '../../data/model/ImageMessage.dart';
import '../../data/model/Inbox.dart';
import '../../data/model/TextMessage.dart';
import '../../data/model/VideoMessage.dart';

class ChatScreenViewModel extends GetxController {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? messageStream;

  Rx<ChatUser> their = ChatUser(uid: '').obs;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  var inbox = [].obs;
  Rx<AudioPlayer> audioPlayer = AudioPlayer().obs;

  void startStream() async {
    logWarning('Start message subscription.');
    messageStream =
        await CloudFirestoreService().getMessageStream(their.value.uid);
    messageStream!.listen((event) async {
      if (event.data() != null) {
        logWarning('Message stream changed.');
        logWarning('Message stream event: ${event.data()!.length}');

        //refilter message
        inbox.value = filter(
            Inbox.fromMap(event.data() ?? {}).messageBox,
            Get.find<UserRepository>().userProvider.value.currentUser!.uid,
            their.value.uid);

        //call to refresh newest message
        Get.find<MessageTabViewModel>().initData();
        scrollDown();
      } else {
        logWarning('Message stream is null.');
      }
    });
  }

  void endStream() {
    logWarning('End message subscription.');
  }

  Future<void> initChatDialog(String myUid, String theirUid) async {
    debugPrint('$myUid chat with $theirUid');
    their.value = (await CloudFirestoreService().getChatUserByUid(theirUid))!;
    startStream();
    inbox.value = (await CloudFirestoreService()
        .getAllMessagesForCurrentDialog(myUid, theirUid))!;
  }

  void sendMessage(dynamic content) {
    switch (content.runtimeType) {
      case String:
        if (content != '') {
          CloudFirestoreService().sendTextMessage(TextMessage(
            content: content,
            senderUid:
                Get.find<UserRepository>().userProvider.value.currentUser!.uid,
            receiverUid: their.value.uid,
            createAt: Timestamp.now(),
            isRemoveBySender: false,
            isRecallByReceiver: false,
            isRecallBySender: false,
          ));
        }
        break;
      default:
        break;
    }
  }

  Widget getMessageBlock(dynamic e) {
    return GestureDetector(
      onLongPress: () {
        Get.bottomSheet(messageOptions(e),
            barrierColor: Colors.transparent,
            enterBottomSheetDuration: const Duration(milliseconds: 200),
            exitBottomSheetDuration: const Duration(milliseconds: 200));
      },
      child: catchTypeOfMessage(e),
    );
  }

  Widget catchTypeOfMessage(dynamic e) {
    bool isMe = e.senderUid ==
        Get.find<UserRepository>().userProvider.value.currentUser!.uid;
    switch (e.runtimeType) {
      case TextMessage:
        return Container(
          constraints: BoxConstraints(
              maxHeight: Get.height * 0.7, maxWidth: Get.width * 0.7),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(16)),
          child: Text(
            e.content,
            maxLines: 100,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      case ImageMessage:
        return GestureDetector(
          onTap: () {
            Get.dialog(
                Stack(alignment: AlignmentDirectional.center, children: [
                  Positioned(
                      top: 20,
                      left: 20,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      )),
                  Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          DownloadManager(e.imageUrl).startDownload();
                        },
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                      )),
                  SizedBox(
                    width: Get.size.width,
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: e.imageUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ]),
                barrierColor: Colors.black);
          },
          child: Container(
              constraints: BoxConstraints(
                  minWidth: Get.size.width * 0.3,
                  maxWidth: Get.size.width * 0.7),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: isMe ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(16)),
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: e.imageUrl,
                placeholder: (context, url) => const CircularProgressIndicator(
                  color: Colors.white,
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              )),
        );
      case AudioMessage:
        try {
          audioPlayer.value.setUrl(e.audioUrl);
        } catch (ignored) {}
        return GestureDetector(
          onTap: () async {
            try {
              audioPlayer.value.playing
                  ? await audioPlayer.value.pause()
                  : audioPlayer.value.play();
              update();
            } catch (error) {
              logError("---------Internal Error: $error");
              audioPlayer.value.setUrl(e.audioUrl);
            }
            // final duration = await player.setUrl(// Load a URL
            //     e.audioUrl); // Schemes: (https: | file: | asset: )
            // player.play();
            // Play without waiting for completion
            // debugPrint(duration.toString());
            // Play while waiting for completion
            // await player.value.pause(); // Pause but remain ready to play
            // await player.seek(Duration(second: 10));        // Jump to the 10 second position
            // await player.setSpeed(2.0);                     // Twice as fast
            // await player.setVolume(0.5);                    // Half as loud
            // await player.stop();
          },
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Icon(
                  audioPlayer.value.playing ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  audioPlayer.value.playing ? "Tap to pause" : "Tap to play",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                    visible: audioPlayer.value.playing,
                    child: const SpinKitWave(
                      size: 10,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        );
      case VideoMessage:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 0.5)),
          child: Container(
            width: Get.size.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Center(child: VideoPlayerView(e.videoUrl)),
          ),
        );
      case FileMessage:
        return GestureDetector(
          onTap: () async {
            Get.dialog(
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 60),
                    color: Colors.white,
                    child: Material(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.arrow_back)),
                              SizedBox(
                                width: Get.size.width / 2,
                                child: Text(
                                  e.fileUrl,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    DownloadManager(e.fileUrl).startDownload();
                                  },
                                  icon: const Icon(Icons.download)),
                            ],
                          ),
                          Expanded(
                              child: Container(
                            color: Colors.grey,
                            //TODO: file viewer
                          ))
                        ],
                      ),
                    )),
                barrierColor: Colors.black54.withOpacity(0.5));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 0.5)),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: const Text(
                    "File",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  width: Get.size.width * 0.7,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16))),
                  child: Column(
                    children: [
                      Text(
                        e.fileUrl,
                        style: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return Container(
          width: 80,
          height: 50,
          color: Colors.red,
          child: const Center(child: Text("Error")),
        );
    }
  }

  Widget messageOptions(dynamic e) {
    return Wrap(children: [
      Container(
        // height: Get.size.height / 5,
        width: Get.size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black45, blurRadius: 10)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  copyToClipboard(e);
                },
                child: Text(
                  e is TextMessage
                      ? 'Copy message to clipboard'
                      : 'Copy URL to clipboard',
                  style: const TextStyle(fontSize: 16),
                )),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {},
                child: const Text(
                  'Remove for me',
                  style: TextStyle(fontSize: 16),
                )),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {},
                child: const Text(
                  'Delete for all',
                  style: TextStyle(fontSize: 16),
                )),
            e is! TextMessage
                ? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        switch (e.runtimeType) {
                          case ImageMessage:
                            DownloadManager(e.imageUrl).startDownload();
                            break;
                          case VideoMessage:
                            DownloadManager(e.videoUrl).startDownload();
                            break;
                          case AudioMessage:
                            DownloadManager(e.audioUrl).startDownload();
                            break;
                          case FileMessage:
                            DownloadManager(e.fileUrl).startDownload();
                            break;
                        }
                        Get.back();
                      },
                      child: const Text(
                        'Download',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    ]);
  }

  void copyToClipboard(e) {
    switch (e.runtimeType) {
      case TextMessage:
        Clipboard.setData(ClipboardData(text: e.content));
        break;
      case ImageMessage:
        Clipboard.setData(ClipboardData(text: e.imageUrl));
        break;
      case VideoMessage:
        Clipboard.setData(ClipboardData(text: e.videoUrl));
        break;
      case AudioMessage:
        Clipboard.setData(ClipboardData(text: e.audioUrl));
        break;
      case FileMessage:
        Clipboard.setData(ClipboardData(text: e.fileUrl));
        break;
    }
    Get.back();
    Get.snackbar(
      'Copied',
      'Copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 16,
      duration: const Duration(milliseconds: 1000),
    );
  }

  List filter(List<dynamic> list, String myUid, String theirUid) {
    var temp = [];
    for (Message i in list) {
      if (i.senderUid == myUid && i.receiverUid == theirUid) {
        temp.add(i);
      }
      if (i.senderUid == theirUid && i.receiverUid == myUid) {
        temp.add(i);
      }
    }
    return temp;
  }

  Future<void> scrollDown() async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }
}
