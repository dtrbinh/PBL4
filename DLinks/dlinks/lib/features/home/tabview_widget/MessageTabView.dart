import 'package:cached_network_image/cached_network_image.dart';
import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:dlinks/features/chat_screen/ChatScreenView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/ChatUser.dart';
import '../../../data/model/Message.dart';
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
    //delay to avoid error when first login
    Future.delayed(const Duration(milliseconds: 100), () {
      viewModel.initData();
    });
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
                  backgroundColor: Colors.black,
                  color: Colors.white,
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
        height: MediaQuery.of(context).size.height / 11,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    their.displayName!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: FutureBuilder(
                      future: CloudFirestoreService().getLastestMessage(
                          viewModel.c.userProvider.value.currentUser!.uid,
                          their.uid),
                      builder: (context, msgSnapshot) {
                        if (msgSnapshot.hasData) {
                          var msg = msgSnapshot.data as Message;
                          return FutureBuilder(
                              future: CloudFirestoreService()
                                  .getChatUserByUid(msg.senderUid),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.hasData) {
                                  var user = userSnapshot.data as ChatUser;
                                  return Text(
                                    "${user.displayName!.split(' ')[0]}: ${msgSnapshot.data}",
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }
                                return const Text("Loading...");
                              });
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
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
