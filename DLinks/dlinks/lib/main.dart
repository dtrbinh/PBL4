import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:dlinks/features/DLinksApplication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'data/model/LifeCycleEventHandler.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  WidgetsBinding.instance.addObserver(LifecycleEventHandler(
    detachedCallBack: (){
      CloudFirestoreService().setChatUserOnline();
    },
    resumeCallBack: (){
      CloudFirestoreService().setChatUserOnline();
    },
  ));

  await FlutterDownloader.initialize(
      debug: false,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const DLinksApplication());
}
