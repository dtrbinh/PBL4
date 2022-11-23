import 'package:cached_network_image/cached_network_image.dart';
import 'package:dlinks/features/chat_screen/ChatScreenView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/ChatUser.dart';
import 'MessageTabViewModel.dart';

class MessageTabView extends StatefulWidget {
  const MessageTabView({Key? key}) : super(key: key);

  @override
  State<MessageTabView> createState() => _MessageTabViewState();
}

class _MessageTabViewState extends State<MessageTabView> {
  final MessageTabViewModel viewModel = Get.put(MessageTabViewModel());

  @override
  void initState() {
    super.initState();
    viewModel.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'DLinks',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Search...",
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Your Messages",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    viewModel.isLoading.value = true;
                    await viewModel.initData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    child: Obx(
                      () => Column(
                        children: viewModel.userInbox.value
                            .map((e) => _dialogCard(e))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _dialogCard(ChatUser their) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ChatScreenView(their.uid));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 12,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Colors.black45, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
              )
            ],
            color: Colors.white),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45, width: 0.5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(their.photoURL!),
                  ),
                  shape: BoxShape.circle),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    their.displayName!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      "Welcome to DLinks an application for sending message with your friend.",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
