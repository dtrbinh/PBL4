// ignore_for_file: file_names

import 'package:dlinks/features/splash/screen/SplashView.dart';
import 'package:flutter/material.dart';

class DLinksApplication extends StatelessWidget {
  const DLinksApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashView(),
    );
  }
}

