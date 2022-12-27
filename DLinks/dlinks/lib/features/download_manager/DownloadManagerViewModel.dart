import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadManagerViewModel extends GetxController {
  FileManagerController controller = FileManagerController();

  RxString title = 'BKZalo'.obs;
  late RxList entities = [].obs;

  void initData() {
    titleListener();
    var defaultPath = '/storage/emulated/0/Android/data/com.example.dlinks/files';
    if (Platform.isAndroid) {
      controller.setCurrentPath = defaultPath;
    } else if (Platform.isIOS) {
    } else {
      controller = FileManagerController();
    }
  }

  void titleListener() {
    Future.delayed(const Duration(seconds: 0), () {
      controller.titleNotifier.addListener(() {
        if (controller.titleNotifier.value == "DLinks"){
          title.value = "BKZalo";
        } else {
          title.value = controller.titleNotifier.value;
        }
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
          return Icons.feed_outlined;
      }
    } else {
      return Icons.folder;
    }
  }

  String getFilename(FileSystemEntity entity){
    return "${FileManager.basename(entity)}.${FileManager.getFileExtension(entity)}";
  }

  FileType getFileTypeFromPath(FileSystemEntity entity){
    var icon = getIcon(entity);
    if (icon == Icons.image) {
      return FileType.Image;
    } else if (icon == Icons.audio_file){
      return FileType.Audio;
    } else if (icon == Icons.video_file){
      return FileType.Video;
    } else if (icon == Icons.feed){
      return FileType.Document;
    } else {
      return FileType.Other;
    }
  }
}

enum FileType {Image, Audio, Video, Document, Other}
