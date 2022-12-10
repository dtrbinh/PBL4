import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dlinks/data/model/Message.dart';
import 'package:dlinks/data/repository/UserRepository.dart';
import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:dlinks/data/services/FirebaseStorageService.dart';
import 'package:dlinks/features/home/tabview_widget/MessageTabViewModel.dart';
import 'package:dlinks/utils/error_manager/ErrorLogger.dart';
import 'package:dlinks/utils/widget/CommonWidget.dart';
import 'package:dlinks/utils/widget/DownloadManager.dart';
import 'package:dlinks/utils/widget/VideoPlayerView.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

import '../../data/model/AudioMessage.dart';
import '../../data/model/ChatUser.dart';
import '../../data/model/FileMessage.dart';
import '../../data/model/ImageMessage.dart';
import '../../data/model/Inbox.dart';
import '../../data/model/TextMessage.dart';
import '../../data/model/VideoMessage.dart';

class ChatScreenViewModel extends GetxController {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? messageStream;
  TextEditingController messageController = TextEditingController();

  Rx<ChatUser> their = ChatUser(uid: '').obs;

  ScrollController scrollController = ScrollController();
  Rx<AudioPlayer> audioPlayer = AudioPlayer().obs;
  var inbox = [].obs;

  // s2t variables
  var isSpeech = false.obs;
  late SpeechToText speechToText;
  var lastWords = ''.obs;

  // file picker variables
  var uploadProgress = 0.0.obs;
  var isUploading = false.obs;

  void startMessageStream() async {
    logWarning('Start message subscription.');
    messageStream = CloudFirestoreService()
        .getMessageStream(Get.find<UserRepository>().userProvider.value.currentUser!.uid); //myUid
    messageStream!.listen((event) async {
      if (event.data() != null) {
        logWarning('Message stream changed.');
        //re filter message
        inbox.value = filter(Inbox.fromMap(event.data() ?? {}).messageBox,
            Get.find<UserRepository>().userProvider.value.currentUser!.uid, their.value.uid);
        //call to refresh newest message
        Get.find<MessageTabViewModel>().initData();
        scrollDown();
      } else {
        logWarning('Message stream is null.');
      }
    });
  }

  void endMessageStream() {
    logWarning('End message subscription.');
  }

  void startTheirUserStream() async {
    logWarning('Start their user subscription.');
    CloudFirestoreService().getTheirUserStream(their.value.uid).listen((event) async {
      if (event.data() != null) {
        logWarning('Their user stream changed.');
        their.value = ChatUser.fromMap(event.data() ?? {});
      } else {
        logWarning('Their user stream is null.');
      }
    });
  }

  void endTheirUserStream() {
    logWarning('End their user subscription.');
  }

  Future<void> initChatDialog(String myUid, String theirUid) async {
    debugPrint('$myUid chat with $theirUid');
    their.value = (await CloudFirestoreService().getChatUserByUid(theirUid))!;
    //stream listen under get message for dialog -> merge 2 message inbox for 2 user
    inbox.value = (await CloudFirestoreService().getAllMessagesForCurrentDialog(myUid, theirUid))!;
    startMessageStream();
    startTheirUserStream();
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
      case String:
        Clipboard.setData(ClipboardData(text: e));
        break;
      default:
        break;
    }
    Get.back();
    Get.snackbar(
      'Copied',
      'Copied to clipboard',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 16,
      duration: const Duration(milliseconds: 1000),
    );
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
    bool isMe = e.senderUid == Get.find<UserRepository>().userProvider.value.currentUser!.uid;
    switch (e.runtimeType) {
      case TextMessage:
        return Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.7, maxWidth: Get.width * 0.7),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: isMe ? Colors.blue : Colors.grey, borderRadius: BorderRadius.circular(16)),
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
                Container(
                  width: Get.size.width,
                  constraints: BoxConstraints(maxHeight: Get.height, maxWidth: Get.width),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                  ),
                ),
                Positioned(
                    top: 20,
                    left: 20,
                    child: Material(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    )),
                Positioned(
                    top: 20,
                    right: 20,
                    child: Material(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          DownloadManager(e.imageUrl).startDownload();
                        },
                        icon: const Icon(
                          Icons.download,
                          color: Colors.black,
                        ),
                      ),
                    )),
              ]),
              barrierColor: Colors.black.withOpacity(0.8),
            );
          },
          child: Container(
              constraints: BoxConstraints(
                  minWidth: Get.size.width * 0.3, maxWidth: Get.size.width * 0.7, maxHeight: Get.size.width * 0.7),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: e.imageUrl,
                placeholder: (context, url) => Container(
                  width: Get.size.width * 0.2,
                  height: Get.size.width * 0.2,
                  color: Colors.transparent,
                  child: const SpinKitFadingCircle(
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: Get.size.width * 0.2,
                  height: Get.size.width * 0.2,
                  color: Colors.transparent,
                  child: const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
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
              audioPlayer.value.playing ? await audioPlayer.value.pause() : audioPlayer.value.play();
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
            decoration: BoxDecoration(color: isMe ? Colors.blue : Colors.grey, borderRadius: BorderRadius.circular(16)),
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
          child: Container(
            constraints: BoxConstraints(
              maxWidth: Get.size.width * 0.7,
              // maxHeight: Get.size.width,
            ),
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
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(width: 0.5)),
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
                      borderRadius:
                          const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                  child: Column(
                    children: [
                      Text(
                        getFileName(e.fileUrl),
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
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  copyToClipboard(e);
                },
                child: Text(
                  e is TextMessage ? 'Copy message to clipboard' : 'Copy URL to clipboard',
                  style: const TextStyle(fontSize: 16),
                )),
            //TODO: implements remove message
            // Padding(
            //   padding: const EdgeInsets.only(top: 20.0),
            //   child: GestureDetector(
            //       onTap: () {},
            //       child: const Text(
            //         'Remove for me',
            //         style: TextStyle(fontSize: 16),
            //       )),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 20.0),
            //   child: GestureDetector(
            //       onTap: () {},
            //       child: const Text(
            //         'Delete for all',
            //         style: TextStyle(fontSize: 16),
            //       )),
            // ),
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
                : const SizedBox.shrink(),
            e is ImageMessage
                ? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        showLoadingDialog(Get.context!);
                        ocrScan(e.imageUrl);
                      },
                      child: const Text(
                        'Extract text',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    ]);
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

  // speech to text
  void initSpeech() async {
    if (await Permission.microphone.request().isGranted) {
      speechToText = SpeechToText();
      await speechToText.initialize(
          onStatus: (val) => logWarning('----------S2T onStatus: $val'),
          onError: (val) => logError('----------S2T onError: $val'));
    } else {
      Get.snackbar('Permission', 'Microphone permission is required');
    }
  }

  void startListening() async {
    logWarning('----------Start listening');
    await speechToText.listen(onResult: _onSpeechResult, sampleRate: 16000);
    isSpeech.value = true;
  }

  void stopListening() async {
    logWarning('----------Stop listening');
    await speechToText.stop();
    messageController.text = '';
    messageController.text = lastWords.value;
    isSpeech.value = false;
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords.value = result.recognizedWords;
    messageController.text = lastWords.value;
    // debugPrint("----------Detect: ${lastWords.value}");
  }

  //send 4 other type off message
  Future<Stream<TaskSnapshot>> pickAndUpload(FileType type, String savingPath) async {
    isUploading.value = true;
    FilePickerResult? result = await FilePicker.platform.pickFiles(dialogTitle: 'Select File', type: type);
    if (result != null) {
      update();
      var stream = await FirebaseStorageService.uploadFile(File(result.files.single.path!), savingPath);
      stream!.listen((event) {}, onError: (e) {
        isUploading.value = false;
        update();
        Get.showSnackbar(GetBar(message: 'Send failed', duration: const Duration(seconds: 1)));
      });
      return stream;
    } else {
      isUploading.value = false;
      update();
    }
    return const Stream.empty();
  }

  Future<void> sendImage() async {
    var uploadStream = await pickAndUpload(FileType.image, 'images/');
    uploadStream.listen(
        (event) async {
          uploadProgress.value = event.bytesTransferred / event.totalBytes;
          update();
          if (uploadProgress.value == 1.0 && event.state == TaskState.success) {
            var url = await event.ref.getDownloadURL();
            logWarning('----------Upload complete: ${await event.ref.getDownloadURL()}');
            if (url != '') {
              sendMessage(ImageMessage(
                imageUrl: url,
                senderUid: Get.find<UserRepository>().userProvider.value.currentUser!.uid,
                receiverUid: their.value.uid,
                createAt: Timestamp.now(),
                isRecallByReceiver: false,
                isRecallBySender: false,
                isRemoveBySender: false,
              ));
            } else {
              debugPrint('Null url: $url');
            }
            uploadProgress.value = 0.0;
            isUploading.value = false;
            update();
          }
        },
        onDone: () async {},
        onError: (e) {
          logError('----------Upload error: $e');
        });
  }

  Future<void> sendAudio() async {
    var uploadStream = await pickAndUpload(FileType.audio, 'audios/');
    uploadStream.listen(
        (event) async {
          uploadProgress.value = event.bytesTransferred / event.totalBytes;
          update();
          if (uploadProgress.value == 1.0 && event.state == TaskState.success) {
            var url = await event.ref.getDownloadURL();
            logWarning('----------Upload complete: ${await event.ref.getDownloadURL()}');
            if (url != '') {
              sendMessage(AudioMessage(
                senderUid: Get.find<UserRepository>().userProvider.value.currentUser!.uid,
                receiverUid: their.value.uid,
                createAt: Timestamp.now(),
                isRecallByReceiver: false,
                isRecallBySender: false,
                isRemoveBySender: false,
                audioUrl: 'url',
              ));
            }
            uploadProgress.value = 0.0;
            isUploading.value = false;
            update();
          }
        },
        onDone: () async {},
        onError: (e) {
          logError('----------Upload error: $e');
        });
  }

  Future<void> sendVideo() async {
    var uploadStream = await pickAndUpload(FileType.video, 'videos/');
    uploadStream.listen(
        (event) async {
          uploadProgress.value = event.bytesTransferred / event.totalBytes;
          update();
          if (uploadProgress.value == 1.0 && event.state == TaskState.success) {
            var url = await event.ref.getDownloadURL();
            logWarning('----------Upload complete: ${await event.ref.getDownloadURL()}');
            if (url != '') {
              sendMessage(VideoMessage(
                videoUrl: url,
                senderUid: Get.find<UserRepository>().userProvider.value.currentUser!.uid,
                receiverUid: their.value.uid,
                createAt: Timestamp.now(),
                isRecallByReceiver: false,
                isRecallBySender: false,
                isRemoveBySender: false,
              ));
            }
            uploadProgress.value = 0.0;
            isUploading.value = false;
            update();
          }
        },
        onDone: () async {},
        onError: (e) {
          logError('----------Upload error: $e');
        });
  }

  Future<void> sendFile() async {
    var uploadStream = await pickAndUpload(FileType.any, 'others/');
    uploadStream.listen(
        (event) async {
          uploadProgress.value = event.bytesTransferred / event.totalBytes;
          update();
          if (uploadProgress.value == 1.0 && event.state == TaskState.success) {
            var url = await event.ref.getDownloadURL();
            logWarning('----------Upload complete: ${await event.ref.getDownloadURL()}');
            if (url != '') {
              sendMessage(FileMessage(
                fileUrl: url,
                senderUid: Get.find<UserRepository>().userProvider.value.currentUser!.uid,
                receiverUid: their.value.uid,
                createAt: Timestamp.now(),
                isRecallByReceiver: false,
                isRecallBySender: false,
                isRemoveBySender: false,
              ));
            }
            uploadProgress.value = 0.0;
            isUploading.value = false;
            update();
          }
        },
        onDone: () async {},
        onError: (e) {
          logError('----------Upload error: $e');
        });
  }

  void sendMessage(dynamic message) {
    switch (message.runtimeType) {
      case String:
        if (message != '') {
          CloudFirestoreService().sendMessage(TextMessage(
            content: message,
            senderUid: Get.find<UserRepository>().userProvider.value.currentUser!.uid,
            receiverUid: their.value.uid,
            createAt: Timestamp.now(),
            isRemoveBySender: false,
            isRecallByReceiver: false,
            isRecallBySender: false,
          ));
        }
        break;
      default:
        CloudFirestoreService().sendMessage(message);
        break;
    }
  }

  String getFileName(String url) {
    RegExp regExp = new RegExp(r'.+(\/|%2F)(.+)\?.+');
    //This Regex won't work if you remove ?alt...token
    var match = regExp.allMatches(url).elementAt(0);
    return Uri.decodeFull(match.group(2)!);
  }

  //image analytics
  Future<File> urlToFile(String imageUrl) async {
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = File('$tempPath${Random().nextInt(100)}.png');
    // call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
    // write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  Future<List<String>> ocrScan(String imageUrl) async {
    List<String> result = [];
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFile(await urlToFile(imageUrl)));
    for (TextBlock block in recognizedText.blocks) {
      //each block of text/section of text
      result.add(block.text);
      for (TextLine line in block.lines) {
        //each line within a text block
        for (TextElement element in line.elements) {
          //each word within a line
        }
      }
    }
    textRecognizer.close();
    hideLoadingDialog(Get.context!);
    if (result.isNotEmpty) {
      Get.dialog(
        Dialog(
          backgroundColor: Colors.white,
          child: Container(
            // height: 200,
            constraints: BoxConstraints(minHeight: 100, maxHeight: Get.height/2),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(result[index]),
                      onTap: () {
                        copyToClipboard(result[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      for (String text in result) {
        logWarning('----------OCR result: $text');
      }
    } else {
      logWarning('----------OCR result: No text found');
    }
    return result;
  }
}
