import 'package:dlinks/utils/AppColor.dart';
import 'package:flutter/material.dart';

class RouteUndefined extends StatelessWidget {
  const RouteUndefined({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColor.PURPLE_1,
      body: Center(
        child: Text('Route Undefined'),
      ),
    );
  }
}
