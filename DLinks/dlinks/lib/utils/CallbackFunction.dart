import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dlinks/utils/error_manager/ErrorLogger.dart';

import '../data/services/CloudFirestoreService.dart';
import '../data/services/LocalCacheService.dart';

Future<void> setChatUserOffline() async {
  logWarning('----------setChatUserOffline: Start');
  LocalCacheService.getString('myUid').then((value) async {
    if (value != null) {
      await CloudFirestoreService().setChatUserLastSeen(value, Timestamp.now());
      await CloudFirestoreService().setChatUserStatus(value, false);
    } else {
      logWarning('----------setChatUserOffline: Fail');
    }
  });
}

Future<void> setChatUserOnline() async {
  logWarning('----------setChatUserOnline: Start');
  LocalCacheService.getString('myUid').then((value) async {
    if (value != null) {
      await CloudFirestoreService().setChatUserLastSeen(value, Timestamp.now());
      await CloudFirestoreService().setChatUserStatus(value, true);
    } else {
      logWarning('----------setChatUserOnline: Fail');
    }
  });
}
