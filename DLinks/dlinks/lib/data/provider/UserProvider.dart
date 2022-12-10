import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserProvider {
  User? currentUser;
  StreamSubscription? connectivitySubscription;

  UserProvider() {
    initNetworkSubscription();
  }

//------------------NETWORK REGION
  void initNetworkSubscription() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      await isHaveInternetConnection();
    });
  }

  Future<bool> isHaveInternetConnection() async {
    //wait for stable connection state, and check if it is "networkable"
    await Future.delayed(const Duration(seconds: 1));
    var state = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        state = true;
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    } on SocketException catch (_) {
      state = false;
      Get.dialog(
        AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                connectivitySubscription?.cancel();
              },
              child: const Text('Exit'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
    return state;
  }

  void logoutCurrentUser() {
    currentUser = null;
  }
}
