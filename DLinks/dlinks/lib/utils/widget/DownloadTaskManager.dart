import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dlinks/utils/error_manager/ErrorLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadTaskManager {
  late String url;
  late ReceivePort port;

  DownloadTaskManager(this.url) {
    port = ReceivePort();
    IsolateNameServer.registerPortWithName(
        port.sendPort, 'downloader_send_port');
    port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) {
        Get.snackbar('Download complete', '',
            duration: const Duration(seconds: 2),
            colorText: Colors.white,
            backgroundColor: Colors.black,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(20));
        IsolateNameServer.removePortNameMapping('downloader_send_port');
      } else if (status == DownloadTaskStatus.failed) {
        Get.snackbar('Download failed', 'Please try later',
            duration: const Duration(seconds: 2),
            colorText: Colors.white,
            backgroundColor: Colors.black,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(20));
        IsolateNameServer.removePortNameMapping('downloader_send_port');
      } else {}
    });
    FlutterDownloader.registerCallback(DownloadTaskManager.downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  void startDownload() async {
    debugPrint('Download started');
    final storage = await Permission.storage.request();
    final manageExternalStorage =
        await Permission.manageExternalStorage.request();
    if (storage.isGranted && manageExternalStorage.isGranted) {
      //TODO: config ios download path
      if (Platform.isAndroid) {
        String? taskId;
        try {
          //TODO: implements directory for iOS
          var docsDir = await getExternalStorageDirectory();
          if (docsDir == null) {
            await Directory(
                    '/storage/emulated/0/Android/data/com.example.dlinks/files')
                .create(recursive: true);
          }
          taskId = await FlutterDownloader.enqueue(
            url: url,
            savedDir:
                docsDir?.path ?? (await getExternalStorageDirectory())!.path,
            showNotification: true,
            openFileFromNotification: true,
            // saveInPublicStorage: true,
          );
        } catch (error) {
          Get.snackbar('Download error.', error.toString(),
              snackPosition: SnackPosition.BOTTOM);
          logError("---------Internal error: $error");
          FlutterDownloader.remove(
              taskId: taskId ?? '', shouldDeleteContent: false);
        }
      } else {
        Get.snackbar('Not supported download on iOS.', '',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      debugPrint('----------Internal Error: Download Permission Denied');
    }
  }
}
