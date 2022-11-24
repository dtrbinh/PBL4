import 'package:dlinks/features/chat_screen/ChatScreenView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/ChatUser.dart';
import 'ContactTabViewModel.dart';

class ContactTabView extends StatefulWidget {
  const ContactTabView({Key? key}) : super(key: key);

  @override
  State<ContactTabView> createState() => _ContactTabViewState();
}

class _ContactTabViewState extends State<ContactTabView> {
  final ContactTabViewModel viewModel = Get.put(ContactTabViewModel());

  @override
  void initState() {
    viewModel.getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 60,
              child: TextFormField(
                controller: viewModel.textEditingController.value,
                decoration: InputDecoration(
                    hintText: "Search other user",
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black45, width: 1),
                        borderRadius: BorderRadius.circular(8))),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            await viewModel.getContact();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(
              () => Column(
                  children:
                      viewModel.contacts.map((e) => _userCard(e)).toList()),
            ),
          ),
        ),
      ),
    ]));
  }

  Widget _userCard(ChatUser user) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ChatScreenView(user.uid));
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
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45, width: 0.5),
                  image: DecorationImage(
                    image: NetworkImage(user.photoURL!),
                  ),
                  shape: BoxShape.circle),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: Get.width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.displayName!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    user.email!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(onPressed: () {}, icon: const Icon(Icons.message))
          ],
        ),
      ),
    );
  }
}
