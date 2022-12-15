import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadManagerViewModel extends GetxController {
  FileManagerController controller = FileManagerController();

  RxString title = 'DLinks'.obs;
  late RxList entities = [].obs;

  void initData() {
    titleListener();
    if (Platform.isAndroid) {
      controller.setCurrentPath = "/storage/emulated/0/Download/DLinks/";
    } else if (Platform.isIOS) {
    } else {
      controller = FileManagerController();
    }
  }

  void titleListener() {
    Future.delayed(const Duration(seconds: 0), () {
      controller.titleNotifier.addListener(() {
        title.value = controller.titleNotifier.value;
        update();
      });
    });
  }

  IconData getIcon(FileSystemEntity entity){
    if (FileManager.isFile(entity)){
      var extension = FileManager.getFileExtension(entity).toLowerCase();
      switch (extension) {
        case "gif":
        case "svg":
        case "jpeg":
        case "png":
        case "jpg":
        case "raw":
          return Icons.image;

        case "flac":
        case "mp3":
        case "wma":
        case "wav":
        case "aac":
        case "ogg":
        case "aiff":
        case "alac":
          return Icons.audio_file;

        case "mp4":
        case "avi":
        case "mov":
        case "flv":
        case "wmv":

          return Icons.video_file;

        case "pdf":
        case "txt":
        case "doc":
        case "docx":
        case "xlsx":
        case "xls":
        case "csv":
        case "ppt":
        case "pptx":
          return Icons.feed;
        default:
          return Icons.feed;
      }
    } else {
      return Icons.folder;
    }
  }

  String getFilename(FileSystemEntity entity){
    return "${FileManager.basename(entity)}.${FileManager.getFileExtension(entity)}";
  }
}
