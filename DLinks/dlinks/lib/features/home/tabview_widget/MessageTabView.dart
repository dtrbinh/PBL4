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
          title: const Text('DLinks'),
        ),
        body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Search...",
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black45, width: 1),
                        borderRadius: BorderRadius.circular(16))),
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
              SizedBox(
                height: Get.size.height - 320,
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Obx(
                    () => viewModel.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : Column(
                            children: viewModel.userInbox.value
                                .map((e) => _dialogCard(e))
                                .toList(),
                          ),
                  ),
                ),
              ),
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black45, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
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
