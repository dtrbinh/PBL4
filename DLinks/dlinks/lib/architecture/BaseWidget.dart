import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'BaseWidgetModel.dart';

/// Apart widget only
abstract class BaseWidget extends StatefulWidget {
  const BaseWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return getWidgetState();
  }

  BaseWidgetState getWidgetState();
}

abstract class BaseWidgetState<T extends BaseWidget, V extends BaseWidgetModel>
    extends State<T>
    with AutomaticKeepAliveClientMixin<T>, WidgetsBindingObserver {
  bool _isVisible = false;

  bool _isFullScreenLoading = false;
  bool _isViewModelReady = false;

  late V _builderModel;

  late V viewModel;

  @override
  void initState() {
    _builderModel = getViewModel();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        viewModel.errorController.stream.listen((error) {
          if (!mounted) return;
        });
        setState(() {
          _isViewModelReady = true;
        });
        WidgetsBinding.instance.addObserver(this);
        onWidgetModelReady();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<V>.value(
        value: _builderModel,
        child: Consumer<V>(builder: (context, viewModel, child) {
          this.viewModel = viewModel;
          return _isViewModelReady
              ? VisibilityDetector(
                  key: Key(runtimeType.toString()),
                  child: getView(),
                  onVisibilityChanged: (visibilityInfo) {
                    _isVisible = visibilityInfo.visibleFraction > 0;
                    if (_isVisible) {
                      onResume();
                    } else {
                      onPause();
                    }
                  })
              : const SizedBox.shrink();
        }));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _isVisible) {
      onResume();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => shouldKeepState();

  void showFullScreenLoading() {
    _isFullScreenLoading = true;
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              const Opacity(opacity: 0.9),
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0.0, -8.0),
                                blurRadius: 8.0,
                                color: Colors.black.withOpacity(0.1))
                          ]),
                      width: 80,
                      height: 80,
                      child: const Center(child: CircularProgressIndicator(),))),
            ],
          ),
        );
      },
    );
  }

  void hideFullScreenLoading() {
    if (_isFullScreenLoading) {
      Navigator.pop(context);
      _isFullScreenLoading = false;
    }
  }

  // required override methods

  bool shouldKeepState() => false;

  V getViewModel();

  Widget getView();

  void onWidgetModelReady();

  void onResume() {}

  void onPause() {}
}
