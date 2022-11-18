import 'package:cached_network_image/cached_network_image.dart';
import 'package:dlinks/data/model/Message.dart';
import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:dlinks/data/services/error_manager/ErrorLogger.dart';
import 'package:dlinks/utils/widget/DownloadManager.dart';
import 'package:dlinks/utils/widget/VideoPlayerView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/model/ChatUser.dart';
import '../../data/model/Inbox.dart';

class ChatScreenViewModel extends GetxController {
  Rx<ChatUser> chatFriend = ChatUser(uid: '').obs;
  Rx<TextEditingController> messageController = TextEditingController().obs;
  Rx<Inbox> inbox = Inbox(uid: '', messageBox: []).obs;

  Rx<AudioPlayer> audioPlayer = AudioPlayer().obs;

  Future<void> initChatDialog(String senderUid) async {
    chatFriend.value = (await Get.find<UserProvider>()
        .authProvider
        .value
        .firebaseService
        .getChatUserByUid(senderUid))!;
    inbox.value = (await Get.find<UserProvider>()
        .authProvider
        .value
        .firebaseService
        .getAllMessagesForUser(
            Get.find<UserProvider>().userRepository.value.currentUser!.uid))!;
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
        Get.find<UserProvider>().userRepository.value.currentUser!.uid;
    switch (e.runtimeType) {
      case TextMessage:
        return Container(
          width: Get.size.width * 0.7,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(16)),
          child: Text(
            e.content,
            style: const TextStyle(color: Colors.white),
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
              // width: Get.size.width * 0.7,
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
        audioPlayer.value.setUrl(e.audioUrl);
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
                  style: const TextStyle(color: Colors.white),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                            decoration: TextDecoration.underline),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {},
                child: const Text(
                  'Remove message for me',
                  style: TextStyle(fontSize: 18),
                )),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {},
                child: const Text(
                  'Remove message for all',
                  style: TextStyle(fontSize: 18),
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
                        'Download to device',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    ]);
  }
}
