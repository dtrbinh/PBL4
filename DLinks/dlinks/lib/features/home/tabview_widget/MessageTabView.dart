import 'package:dlinks/architecture/BaseWidget.dart';
import 'package:dlinks/architecture/BaseWidgetModel.dart';
import 'package:flutter/material.dart';

import 'MessageTabViewModel.dart';

class MessageTabView extends BaseWidget {
  final MessageTabViewModel model;

  const MessageTabView(this.model, {Key? key}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget, BaseWidgetModel> getWidgetState() {
    return _MessageTabViewState();
  }
}

class _MessageTabViewState
    extends BaseWidgetState<MessageTabView, MessageTabViewModel> {
  @override
  Widget getView() {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat with ..'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Expanded(
              //   child: StreamBuilder(
              //       initialData: null,
              //       stream:,
              //       builder: (context, snapshot) {
              //         return SingleChildScrollView(
              //           child: ListView.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: itemCount),
              //         );
              //       }),
              // ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 7,
              )
            ],
          ),
        ));
  }

  @override
  MessageTabViewModel getViewModel() {
    return widget.model;
  }

  @override
  void onWidgetModelReady() {}
}
